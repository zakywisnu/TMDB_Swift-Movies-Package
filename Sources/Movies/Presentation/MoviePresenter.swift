//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 20/02/21.
//

import Foundation
import Combine
import Core

public class MoviePresenter<MovieUseCase: UseCase, FavoriteUseCase: UseCase>: ObservableObject
where
    MovieUseCase.Request == Int, MovieUseCase.Response == MovieModel,
    FavoriteUseCase.Request == Int, FavoriteUseCase.Response == MovieModel {

    private var cancellables: Set<AnyCancellable> = []
    
    private let _movieUseCase: MovieUseCase
    private let _favoriteUseCase: FavoriteUseCase
    
    public init(
        movieUseCase: MovieUseCase,
        favoriteUseCase: FavoriteUseCase
    ) {
        _movieUseCase = movieUseCase
        _favoriteUseCase = favoriteUseCase
    }
    
    @Published public var item: MovieModel?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    
    public func getMovie(request: MovieUseCase.Request) {
        isLoading = true
        _movieUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    self.isError = true
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { item in
                self.item = item
            }).store(in: &cancellables)
    }
    
    public func updateFavoriteMovie(request: FavoriteUseCase.Request){
        _favoriteUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { item in
                self.item = item
            }).store(in: &cancellables)
    }
    
}
