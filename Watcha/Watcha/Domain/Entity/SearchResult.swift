//
//  SearchResult.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public struct SearchResult: Decodable {
    let data: [GIFData]
    let meta: MetaData
    let pagination: Pagination
}


struct MetaData: Decodable {
    let status: Int
    let msg: String
}

struct Pagination: Decodable {
    let totalCount: Int
    let count: Int
    let offset: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
}
