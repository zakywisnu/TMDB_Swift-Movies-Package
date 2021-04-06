//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 20/02/21.
//

import Core
import Combine
import Cleanse

public struct UpdateFavoriteMovieRepository<
    MovieLocalDataSource: LocalDataSource,
    Transformer: Mapper>: Repository
where
    MovieLocalDataSource.Request == Int,
    MovieLocalDataSource.Response == MovieEntity,
    Transformer.Request == Int,
    Transformer.Response == MovieResponse,
    Transformer.Entity == MovieEntity,
    Transformer.Domain == MovieModel {
    
    public typealias Request = Int
    public typealias Response = MovieModel
    
    private let _localeDataSource: MovieLocalDataSource
    private let _mapper: Transformer
    
    public init(
        localeDataSource: MovieLocalDataSource,
        mapper: Transformer) {
        
        _localeDataSource = localeDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> AnyPublisher<MovieModel, Error> {
        return _localeDataSource.get(id: request ?? 0)
            .map{_mapper.transformEntityToDomain(entity: $0)}
            .eraseToAnyPublisher()
    }
}

extension UpdateFavoriteMovieRepository {
    struct Module: Cleanse.Module {
        static func configure(binder: Binder<Singleton>) {
            binder.include(module: GetFavoriteLocalDataSource.Module.self)
            binder.bind(UpdateFavoriteMovieRepository.self).to(factory: UpdateFavoriteMovieRepository.init)
        }
    }
}
