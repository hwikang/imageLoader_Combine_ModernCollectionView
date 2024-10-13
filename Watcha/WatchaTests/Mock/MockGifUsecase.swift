//
//  MockGifUsecase.swift
//  WatchaTests
//
//  Created by hwikang on 10/13/24.
//

import Foundation
@testable import Watcha

class MockGifUsecase: GifUsecaseProtocol {
    var fetchResult: Result<SearchResult, NetworkError>?
    var favoriteList: [String] = []
    
    func fetchGifData(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        return fetchResult ?? .failure(.dataNil)
    }
    
    func getFavoriteIDList() -> [String] {
        return favoriteList
    }
    
    func appendFavoriteID(id: String) {
        favoriteList.append(id)
    }
    
    func removeFavoriteID(id: String) {
        favoriteList.removeAll { $0 == id }
    }
    
    func checkFavorite(dataList: [GIFData]) -> [GIFData] {
        return dataList.map { gif in
            var gif = gif
            gif.isFavorite = favoriteList.contains(gif.id)
            return gif
        }
    }
}
