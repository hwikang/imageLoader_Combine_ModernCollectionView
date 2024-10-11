//
//  GifNetwork.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public protocol GifNetworkProtocol {
    func fetchDutchResult(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError>
}

public struct GifNetwork: GifNetworkProtocol {
    private let manager: NetworkManagerProtocol
    private let baseURL = "https://api.giphy.com/v1/gifs/search"
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }

    public func fetchDutchResult(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        guard let apiKey = Bundle.main.apiKey else { return .failure(.requestFailed("API Key nil"))}

        let url = baseURL
        let queryParams: [String : Any] = [
            "api_key": apiKey,
            "q": query,
            "limit": limit,
            "offset": offset
        ]
        return await manager.fetchData(urlString: url, httpMethod: .get, headers: nil, queryParams: queryParams)
        
    }
    
}
