//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 20/02/21.
//

import Core
import Combine

public struct UpdateFavoriteMovieRepository<
    MovieLocalDataSource: LocalDataSource,
    Transformer: Mapper>: Repository
where
    MovieLocalDataSource.Request == Int,
    MovieLocalDataSource.Response == MovieEntity,
    Transformer.Request == String,
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
