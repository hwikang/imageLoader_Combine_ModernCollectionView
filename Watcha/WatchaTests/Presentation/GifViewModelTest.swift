//
//  GifViewModelTest.swift
//  WatchaTests
//
//  Created by hwikang on 10/13/24.
//

import Foundation
import XCTest
import Combine
@testable import Watcha

class GifViewModelTests: XCTestCase {
    
    var mockUsecase: MockGifUsecase?
    var viewModel: GifViewModel?
    var cancellables: Set<AnyCancellable> = []
    var searchText: PassthroughSubject<String, Never>?
    var loadMore: PassthroughSubject<Void, Never>?
    var addFavorite: PassthroughSubject<String, Never>?
    var deleteFavorite: PassthroughSubject<String, Never>?
    
    var input: GifViewModel.Input?
    override func setUp() {
        super.setUp()
        
        let mockUsecase = MockGifUsecase()
        self.mockUsecase = mockUsecase
        viewModel = GifViewModel(usecase: mockUsecase)
        let searchText = PassthroughSubject<String, Never>()
        let loadMore = PassthroughSubject<Void, Never>()
        let addFavorite = PassthroughSubject<String, Never>()
        let deleteFavorite = PassthroughSubject<String, Never>()
        self.searchText = searchText
        self.loadMore = loadMore
        self.addFavorite = addFavorite
        self.deleteFavorite = deleteFavorite
        
        input = GifViewModel.Input(
            addFavorite: addFavorite.eraseToAnyPublisher(),
            deleteFavorite: deleteFavorite.eraseToAnyPublisher(),
            searchText: searchText.eraseToAnyPublisher(),
            loadMore: loadMore.eraseToAnyPublisher()
        )

    }
    
    override func tearDown() {
        mockUsecase = nil
        viewModel = nil
        cancellables = []
        searchText = nil
        loadMore = nil
        addFavorite = nil
        deleteFavorite = nil
        input = nil
        super.tearDown()
    }
    
    
    // Search Text를 입력했을 때 CellData 섹션별로 리턴되는지 테스트
    func testSearchTextFetchSuccess() async {
        guard let viewModel = viewModel else { XCTFail("viewModel is nil"); return }
        guard let input = input else { XCTFail("input is nil"); return}
        
        let gifData = [
            GIFData(id: "gif1", username: "user1", title: "Funny Cat", originalURLString: "https://giphy.com/original1", previewURLString: "https://giphy.com/preview1"),
            GIFData(id: "gif2", username: "user2", title: "Dancing Dog", originalURLString: "https://giphy.com/original2", previewURLString: "https://giphy.com/preview2"),
            GIFData(id: "gif3", username: "user3", title: "Laughing Baby", originalURLString: "https://giphy.com/original3", previewURLString: "https://giphy.com/preview3"),
            GIFData(id: "gif4", username: "user4", title: "Excited Bird", originalURLString: "https://giphy.com/original4", previewURLString: "https://giphy.com/preview4"),
            GIFData(id: "gif5", username: "user5", title: "Silly Monkey", originalURLString: "https://giphy.com/original5", previewURLString: "https://giphy.com/preview5"),
            GIFData(id: "gif6", username: "user6", title: "Jumping Rabbit", originalURLString: "https://giphy.com/original6", previewURLString: "https://giphy.com/preview6"),
            GIFData(id: "gif7", username: "user7", title: "Happy Elephant", originalURLString: "https://giphy.com/original7", previewURLString: "https://giphy.com/preview7"),
            GIFData(id: "gif8", username: "user8", title: "Cute Kitten", originalURLString: "https://giphy.com/original8", previewURLString: "https://giphy.com/preview8"),
            GIFData(id: "gif9", username: "user9", title: "Swimming Fish", originalURLString: "https://giphy.com/original9", previewURLString: "https://giphy.com/preview9"),
            GIFData(id: "gif10", username: "user10", title: "Rolling Panda", originalURLString: "https://giphy.com/original10", previewURLString: "https://giphy.com/preview10"),
            GIFData(id: "gif11", username: "user11", title: "Dancing Parrot", originalURLString: "https://giphy.com/original11", previewURLString: "https://giphy.com/preview11"),
            GIFData(id: "gif12", username: "user12", title: "Running Fox", originalURLString: "https://giphy.com/original12", previewURLString: "https://giphy.com/preview12")
        ]

        let searchResult = SearchResult(data: gifData, meta: .init(status: 200, msg: "OK"), pagination: Pagination(totalCount: 11, count: 11, offset: 0))
        mockUsecase?.fetchResult = .success(searchResult)

        let expectation = XCTestExpectation(description: "GIF data fetched")
        
        viewModel.transform(input: input).cellData
            .sink { snapshot in
                XCTAssertEqual(snapshot.numberOfItems(inSection: .main), 1, "Expected 1 item in main section")
                XCTAssertEqual(snapshot.numberOfItems(inSection: .carousel), 10, "Expected 10 items in carousel section")
                XCTAssertEqual(snapshot.numberOfItems(inSection: .grid), 1, "Expected 1 item in grid section")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // 4. 검색어 입력
        searchText?.send("funny cats")
        
        // 5. 비동기 테스트 대기
        wait(for: [expectation], timeout: 2.0)
    }
}
