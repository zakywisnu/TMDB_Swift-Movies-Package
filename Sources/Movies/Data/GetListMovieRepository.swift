//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 20/02/21.
//

import Core
import Combine

public struct GetListMovieRepository<
    MovieLocalDataSource: LocalDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper>: Repository
where
    MovieLocalDataSource.Request == Int,
    MovieLocalDataSource.Response == MovieEntity,
    RemoteDataSource.Request == Int,
    RemoteDataSource.Response == [MovieResponse],
    Transformer.Request == Int,
    Transformer.Response == [MovieResponse],
    Transformer.Domain == [MovieModel],
    Transformer.Entity == [MovieEntity] {
    
    public typealias Request = Int
    public typealias Response = [MovieModel]
    
    private let _localDataSource: MovieLocalDataSource
    private let _remoteDataSource: RemoteDataSource
    private let _mapper: Transformer
    
    public init(
        localDataSource: MovieLocalDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer
    ) {
        _localDataSource = localDataSource
        _remoteDataSource = remoteDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> AnyPublisher<[MovieModel], Error> {
        return _localDataSource.list(request: request)
            .flatMap{ result -> AnyPublisher<[MovieModel], Error> in
                if result.isEmpty {
                    return _remoteDataSource.execute(request: request)
                        .map{ _mapper.transformResponseToEntity(request: request, response: $0)}
                        .catch{ _ in _localDataSource.list(request: request)}
                        .flatMap{ _localDataSource.add(entities: $0)}
                        .filter{ $0 }
                        .flatMap{ _ in _localDataSource.list(request: request)}
                        .map{ _mapper.transformEntityToDomain(entity: $0)}
                        .eraseToAnyPublisher()
                } else {
                    return _localDataSource.list(request: request)
                        .map{ _mapper.transformEntityToDomain(entity: $0)}
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
}
