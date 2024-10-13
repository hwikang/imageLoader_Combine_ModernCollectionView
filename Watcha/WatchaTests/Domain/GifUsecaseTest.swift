//
//  GifUsecaseTest.swift
//  WatchaTests
//
//  Created by hwikang on 10/13/24.
//

import Foundation
import XCTest
@testable import Watcha

class GifUsecaseTests: XCTestCase {

    var mockRepository: MockGifRepository?
    var gifUsecase: GifUsecase?

    override func setUp() {
        super.setUp()
        
        let mockRepository = MockGifRepository()
        self.mockRepository = mockRepository
        gifUsecase = GifUsecase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        gifUsecase = nil
        super.tearDown()
    }
   
    
    // 즐겨찾기 여부 확인
    func testCheckFavorite() {
        guard let gifUsecase = gifUsecase else { XCTFail("gifUsecase is nil"); return}
        mockRepository?.favoriteIDList = ["id1", "id3"]
        
        let mockGIFDataList: [GIFData] = [
            GIFData(id: "id1", username: "user1", title: "Funny Cat", originalURLString: "https://giphy.com/original1", previewURLString: "https://giphy.com/preview1"),
            GIFData(id: "id2", username: "user2", title: "Dancing Dog", originalURLString: "https://giphy.com/original2", previewURLString: "https://giphy.com/preview2"),
            GIFData(id: "id3", username: "user3", title: "Laughing Baby", originalURLString: "https://giphy.com/original3", previewURLString: "https://giphy.com/preview3"),
            GIFData(id: "id4", username: "user4", title: "Excited Bird", originalURLString: "https://giphy.com/original4", previewURLString: "https://giphy.com/preview4")
        ]

        let updatedList = gifUsecase.checkFavorite(dataList: mockGIFDataList)
        

        XCTAssertEqual(updatedList[0].isFavorite, true)
        XCTAssertEqual(updatedList[1].isFavorite, false)
        XCTAssertEqual(updatedList[2].isFavorite, true)
    }
}
