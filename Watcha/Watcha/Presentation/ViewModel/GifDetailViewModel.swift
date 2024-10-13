//
//  GifDetailViewModel.swift
//  Watcha
//
//  Created by hwikang on 10/13/24.
//

import Foundation
import Combine

protocol GifDetailViewModelProtocol {
    func transform(input: GifDetailViewModel.Input) -> GifDetailViewModel.Output
}
public class GifDetailViewModel: GifDetailViewModelProtocol {
    private let usecase: GifUsecaseProtocol
    private let gifID: String
    private var cancellables = Set<AnyCancellable>()

    init(usecase: GifUsecaseProtocol, gifID: String) {
        self.usecase = usecase
        self.gifID = gifID
    }
    
    struct Input {
        let changeFavorite: AnyPublisher<Bool, Never>
    }
    struct Output {
        let isFavorite: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        let changedValue = input.changeFavorite
            .handleEvents(receiveOutput: { [weak self] changeToFavorite in
                guard let self = self else { return }
                if changeToFavorite {
                    usecase.appendFavoriteID(id: gifID)
                } else {
                    usecase.removeFavoriteID(id: gifID)
                }
            })
        return Output(isFavorite: changedValue.eraseToAnyPublisher())
    }
}
