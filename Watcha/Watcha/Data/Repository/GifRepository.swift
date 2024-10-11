//
//  GifRepository.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public struct GifRepository {
    private let network: GifNetworkProtocol
    init(network: GifNetworkProtocol) {
        self.network = network
    }
    func fetchDutchResult(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        await network.fetchDutchResult(query: query, limit: limit, offset: offset)
    }
    
    func getFavoriteIDList() -> [String] {
        return UserDefaultValues.favoriteIDList ?? []
    }
    
    func appendFavoriteID(id: String) {
        var list = UserDefaultValues.favoriteIDList ?? []
        list.append(id)
        UserDefaultValues.favoriteIDList = list
    }
    
    func removeFavoriteID(id: String) {
        var list = UserDefaultValues.favoriteIDList ?? []
        list.removeAll {$0 == id}
        UserDefaultValues.favoriteIDList = list
    }
}
