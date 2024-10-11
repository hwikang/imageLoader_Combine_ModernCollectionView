//
//  GifData.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

struct GIFData: Decodable {
    let id: String
    let username: String
    let title: String
    let originalURLString: String
    let previewURLString: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.title = try container.decode(String.self, forKey: .title)
        let imagesContainer = try container.nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .images)
        let originalContainer = try imagesContainer.nestedContainer(keyedBy: ImageDetailCodingKeys.self, forKey: .original)
        let previewContainer = try imagesContainer.nestedContainer(keyedBy: ImageDetailCodingKeys.self, forKey: .original)
        self.originalURLString = try originalContainer.decode(String.self, forKey: .url)
        self.previewURLString = try previewContainer.decode(String.self, forKey: .url)
    }

    enum CodingKeys: CodingKey {
        case id
        case username
        case title
        case images
    }
    
    enum ImagesCodingKeys: String, CodingKey {
        case original
        case preview = "preview_gif"
    }
    
    enum ImageDetailCodingKeys: CodingKey {
        case url
    }
    
}

