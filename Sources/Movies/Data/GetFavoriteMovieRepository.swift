//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 20/02/21.
//

import Core
import Combine
import Cleanse

public struct GetFavoriteMovieRepository<
    MovieLocalDataSource: LocalDataSource,
    Transformer: Mapper>: Repository
where
    MovieLocalDataSource.Request == Int,
    MovieLocalDataSource.Response == MovieEntity,
    Transformer.Request == Int,
    Transformer.Response == [MovieResponse],
    Transformer.Entity == [MovieEntity],
    Transformer.Domain == [MovieModel] {
    
    public typealias Request = Int
    public typealias Response = [MovieModel]
    
    private let _localDataSource: MovieLocalDataSource
    private let _mapper: Transformer
    
    public init(
        localDataSource: MovieLocalDataSource,
        mapper: Transformer
    ) {
        _localDataSource = localDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> AnyPublisher<[MovieModel], Error> {
        return _localDataSource.list(request: request)
            .map{ _mapper.transformEntityToDomain(entity: $0)}
            .eraseToAnyPublisher()
    }
    
}
public extension GetFavoriteMovieRepository {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Singleton>) {
            binder.bind(GetFavoriteMovieRepository.self).to(factory: GetFavoriteMovieRepository.init)
        }
    }
}
