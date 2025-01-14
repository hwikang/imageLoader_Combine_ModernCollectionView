//
//  Extension + UIImageView.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import UIKit

extension UIImageView {

    func setImage(urlString: String, completion: @escaping (URLSessionDataTask?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        if let cachedImage = ImageCacheManager.shared.image(forKey: url as NSURL) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
            }
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let url = URL(string: urlString) {
                let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                    var finalImage = downloadedImage
                    
                    let maxSize = 500000 //500KB
                    if data.count > maxSize {
                        let compressionRatio = CGFloat(maxSize) / CGFloat(data.count)
                        let compressionQuality = max(min(compressionRatio, 1.0), 0.1)
                        if let compressedData = downloadedImage.jpegData(compressionQuality: compressionQuality) {
                            finalImage = UIImage(data: compressedData) ?? downloadedImage
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self?.image = finalImage
                    }
                    ImageCacheManager.shared.setImage(finalImage, forKey: url as NSURL)
                }
                dataTask.resume()
                            
                DispatchQueue.main.async {
                    completion(dataTask)
                }
            }
        }
    }
    
    func setGifFromUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if let cachedImage = GifCacheManager.shared.image(forKey: url as NSURL) {
            DispatchQueue.main.async { [weak self] in
                self?.startGif(image: cachedImage)
            }
            return
        }
        
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let gifImages = loadGif(from: url) {
                DispatchQueue.main.async { [weak self] in
                    self?.startGif(image: gifImages)
                }
                
                GifCacheManager.shared.setImage(gifImages, forKey: url as NSURL)
                
            }
        }
    }
    
    func stopGif() {
        stopAnimating()
        animationImages = nil
    }
    
    private func startGif(image: [UIImage]) {
        animationImages = image
        animationDuration = Double(image.count) * 0.1
        startAnimating()
    }
    
    private func loadGif(from url: URL) -> [UIImage]? {
        
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        let count = min(CGImageSourceGetCount(source), 50) // 최대 프레임 수
        
        var images = [UIImage]()
        var duration: TimeInterval = 0
        
        //프레임 정보 가져오기
        let properties = CGImageSourceCopyProperties(source, nil) as? [String: Any]
        let gifProperties = properties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        let framedDurations = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime as String] as? [Double]
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                duration += framedDurations?[i] ?? 0.1
            }
        }
        return images
    }
    
}
