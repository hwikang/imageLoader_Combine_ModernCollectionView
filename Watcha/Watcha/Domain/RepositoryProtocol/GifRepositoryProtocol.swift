//
//  GifRepositoryProtocol.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public protocol GifRepositoryProtocol {
    func fetchGifData(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError>
    func getFavoriteIDList() -> [String]
    func appendFavoriteID(id: String)
    func removeFavoriteID(id: String)
}
