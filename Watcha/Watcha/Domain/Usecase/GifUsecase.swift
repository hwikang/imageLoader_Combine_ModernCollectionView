//
//  GifUsecase.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

protocol GifUsecaseProtocol {
    func fetchGifData(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError>
    func getFavoriteIDList() -> [String]
    func appendFavoriteID(id: String)
    func removeFavoriteID(id: String)
    func checkFavorite(dataList: [GIFData]) -> [GIFData]
}

public struct GifUsecase {
    private let repository: GifRepositoryProtocol
    init(repository: GifRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchGifData(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        await repository.fetchGifData(query: query, limit: limit, offset: offset)
    }
    
    func getFavoriteIDList() -> [String] {
        repository.getFavoriteIDList()
    }
    
    func appendFavoriteID(id: String) {
        repository.appendFavoriteID(id: id)
    }
    
    func removeFavoriteID(id: String) {
        repository.removeFavoriteID(id: id)
    }
    
    func checkFavorite(dataList: [GIFData]) -> [GIFData] {
        let favorite = Set(repository.getFavoriteIDList())
        return dataList.map { data in
            var data = data
            if favorite.contains(data.id) {
                data.isFavorite = true
            }
            return data
        }
    }
}
