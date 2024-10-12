//
//  GifRepository.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public struct GifRepository: GifRepositoryProtocol {
    private let network: GifNetworkProtocol
    init(network: GifNetworkProtocol) {
        self.network = network
    }
    public func fetchGifData(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        await network.fetchGifData(query: query, limit: limit, offset: offset)
    }
    
    public func getFavoriteIDList() -> [String] {
        return UserDefaultValues.favoriteIDList ?? []
    }
    
    public func appendFavoriteID(id: String) {
        var list = UserDefaultValues.favoriteIDList ?? []
        list.append(id)
        UserDefaultValues.favoriteIDList = list
    }
    
    public func removeFavoriteID(id: String) {
        var list = UserDefaultValues.favoriteIDList ?? []
        list.removeAll {$0 == id}
        UserDefaultValues.favoriteIDList = list
    }
}
