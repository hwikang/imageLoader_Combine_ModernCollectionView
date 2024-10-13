//
//  GifViewModel.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import Foundation
import UIKit
import Combine

protocol GifViewModelProtocol {
    func transform(input: GifViewModel.Input) -> GifViewModel.Output
}

public class GifViewModel: GifViewModelProtocol {
    private let usecase: GifUsecaseProtocol
    private let limit = 50
    private var offset = 0

    private let pageFinished = CurrentValueSubject<Bool, Never>(false)

    private let query = CurrentValueSubject<String, Never>("")
    private let gifDataList = CurrentValueSubject<[GIFData], Never>([])
    private let errorMessage = PassthroughSubject<String,Never>()
    private var cancellables = Set<AnyCancellable>()

    init(usecase: GifUsecaseProtocol) {
        self.usecase = usecase
    }
    struct Input {
        let addFavorite: AnyPublisher<String, Never>
        let deleteFavorite: AnyPublisher<String, Never>
        let searchText: AnyPublisher<String,Never>
        let loadMore: AnyPublisher<Void,Never>
    }
    struct Output {
        let cellData: AnyPublisher<NSDiffableDataSourceSnapshot<Section, CellData>, Never>
        let errorMessage: AnyPublisher<String,Never>
        
    }
    
    func transform(input: Input) -> Output {
      
        input.searchText
            .filter({ !$0.isEmpty })
            .compactMap { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)}
            .handleEvents(receiveOutput: { [weak self] query in
                self?.gifDataList.send([])
                self?.query.send(query)
                self?.offset = 0
            })
            .sink { [weak self] query in
                guard let self = self else { return }
                
                Task {
                    await self.fetchGifData(query: query, offset: self.offset)
                }
            }.store(in: &cancellables)
        
        input.loadMore
            .filter { [weak self] _ in self?.pageFinished.value == false }
            .map { [weak self] in self?.query.value }
            .map({ $0 ?? "" })
            .sink { [weak self] query in
            guard let self = self else { return }
            offset += 1
            Task {
                await self.fetchGifData(query: query, offset: self.offset)
            }
        }.store(in: &cancellables)
        
        input.addFavorite.sink { [weak self] id in
            guard let self = self else { return }
            usecase.appendFavoriteID(id: id)
            let checkedData = usecase.checkFavorite(dataList: gifDataList.value)
            gifDataList.send(checkedData)
        }.store(in: &cancellables)
        
        input.deleteFavorite.sink { [weak self] id in
            guard let self = self else { return }
            usecase.removeFavoriteID(id: id)
            let checkedData = usecase.checkFavorite(dataList: gifDataList.value)
            gifDataList.send(checkedData)
        }.store(in: &cancellables)
        
        
        let cellData = gifDataList
            .dropFirst()
            .map { dataList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, CellData>()
            snapshot.appendSections([.main, .carousel, .grid])
            dataList.enumerated().forEach { index, data in
                let cellData = CellData.gifCell(data)
                if index == 0 {
                    snapshot.appendItems([cellData], toSection: .main)
                } else if 1..<11 ~= index {
                    snapshot.appendItems([cellData], toSection: .carousel)
                } else {
                    snapshot.appendItems([cellData], toSection: .grid)
                }
            }
            return snapshot
        }.eraseToAnyPublisher()
        
        
        return Output(cellData: cellData, errorMessage: errorMessage.eraseToAnyPublisher())
    }
    
    private func fetchGifData(query: String, offset: Int) async {
        let result = await usecase.fetchGifData(query: query, limit: limit, offset: offset)
        switch result {
        case .success(let success):
            let checkedData = usecase.checkFavorite(dataList: success.data)
            if offset == 0 {
                gifDataList.send(checkedData)
            } else {
                gifDataList.send(gifDataList.value + checkedData)
            }
            pageFinished.send(success.pagination.count < limit)
        case .failure(let failure):
            errorMessage.send(failure.description)
        }
    }
    
}
