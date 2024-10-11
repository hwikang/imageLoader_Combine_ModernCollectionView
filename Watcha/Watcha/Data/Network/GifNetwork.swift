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

public struct GifNetwork {
    private let manager: NetworkManagerProtocol
    private let baseURL = "https://api.giphy.com/v1/gifs/search"
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }

    public func fetchDutchResult(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        guard let apiKey = Bundle.main.apiKey else { return .failure(.requestFailed("API Key nil"))}

        let url = baseURL
        let headers: [String : String] = [
            "api_key": apiKey
        ]
        let queryParams: [String : Any] = [
            "q": query,
            "limit": limit,
            "offset": offset
        ]
        return await manager.fetchData(urlString: url, httpMethod: .get, headers: headers, queryParams: queryParams)
        
    }
    
}
