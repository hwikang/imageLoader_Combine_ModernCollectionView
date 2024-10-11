//
//  SearchResult.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public struct SearchResult: Decodable {
    let data: GIFData
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
}
