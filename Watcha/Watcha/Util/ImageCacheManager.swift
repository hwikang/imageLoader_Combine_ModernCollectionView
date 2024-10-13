//
//  ImageCacheManager.swift
//  Watcha
//
//  Created by hwikang on 10/13/24.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {
        cache.totalCostLimit = 200 * 1024 * 1024 // 50MB
    }

    private let cache = NSCache<NSURL, UIImage>()

    func setImage(_ image: UIImage, forKey key: NSURL) {
        cache.setObject(image, forKey: key)
    }
    
    func image(forKey key: NSURL) -> UIImage? {
        if let image = cache.object(forKey: key) {
            return image
        }
        return nil
        
    }
    
}
