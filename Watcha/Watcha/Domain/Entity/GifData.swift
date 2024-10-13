//
//  GifData.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public struct GIFData: Decodable, Hashable {
    let id: String
    let username: String
    let title: String
    let originalURLString: String
    let previewURLString: String
    var isFavorite: Bool = false
    
    init(id: String, username: String, title: String, originalURLString: String, previewURLString: String) {
        self.id = id
        self.username = username
        self.title = title
        self.originalURLString = originalURLString
        self.previewURLString = previewURLString
    }

    public init(from decoder: any Decoder) throws {
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

