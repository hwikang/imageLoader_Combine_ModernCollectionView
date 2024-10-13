//
//  GifCacheManager.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import UIKit

class GifCacheManager {
    static let shared = GifCacheManager()
    private init() {
        cache.totalCostLimit = 100 * 1024 * 1024 // 200MB

    }

    private let cache = NSCache<NSURL, NSArray>()

    func setImage(_ images: [UIImage], forKey key: NSURL) {
        cache.setObject(images as NSArray, forKey: key)
        
    }
    
    func image(forKey key: NSURL) -> [UIImage]? {
        if let images = cache.object(forKey: key) as? [UIImage] {
            return images
        }
        return nil
    }
}
