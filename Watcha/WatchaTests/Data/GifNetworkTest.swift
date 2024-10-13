//
//  GifNetworkTest.swift
//  WatchaTests
//
//  Created by hwikang on 10/13/24.
//

import XCTest
@testable import Watcha

class GifNetworkIntegrationTests: XCTestCase {
    
    var gifNetwork: GifNetwork?

    override func setUp() {
        super.setUp()
        let networkManager = NetworkManager(session: URLSession.shared)
        gifNetwork = GifNetwork(manager: networkManager)
    }

    override func tearDown() {
        gifNetwork = nil
        super.tearDown()
    }

    // 실제 네트워크 호출 테스트
    func testFetchGifData_ActualNetworkCall() async {
        guard let gifNetwork = gifNetwork else { return XCTFail("gifNetwork is nil") }

        let result = await gifNetwork.fetchGifData(query: "Test", limit: 1, offset: 0)

        switch result {
        case .success(let searchResult):
            XCTAssertEqual(searchResult.meta.status, 200)
        case .failure(let error):
            XCTFail("Expected successful network call, but got error: \(error)")
        }
    }
}
