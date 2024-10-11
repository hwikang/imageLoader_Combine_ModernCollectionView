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
}
