//
//  MockGifNetwork.swift
//  WatchaTests
//
//  Created by hwikang on 10/13/24.
//

import Foundation
@testable import Watcha

class MockGifNetwork: GifNetworkProtocol {
    var resultToReturn: Result<SearchResult, NetworkError>?
    
    func fetchGifData(query: String, limit: Int, offset: Int) async -> Result<SearchResult, NetworkError> {
        return resultToReturn ?? .failure(NetworkError.dataNil)
    }
}
