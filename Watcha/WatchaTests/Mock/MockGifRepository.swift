//
//  MockGifRepository.swift
//  WatchaTests
//
//  Created by hwikang on 10/13/24.
//

import Foundation
@testable import Watcha

class MockGifRepository: GifRepositoryProtocol {
    var favoriteIDList: [String] = []
    var fetchResult: Result<SearchResult, NetworkError>?

    func fetchGifData(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        return fetchResult ?? .failure(.dataNil)
    }
    
    func getFavoriteIDList() -> [String] {
        return favoriteIDList
    }
    
    func appendFavoriteID(id: String) {
        favoriteIDList.append(id)
    }
    
    func removeFavoriteID(id: String) {
        favoriteIDList.removeAll { $0 == id }
    }

}
