//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 20/02/21.
//

import Core
import Combine
import Cleanse

public struct GetDetailMovieRepository<MovieLocalDataSource: LocalDataSource,
                                       RemoteDataSource: DataSource,
                                       Transformer: Mapper>: Repository
where
    MovieLocalDataSource.Request == Int,
    MovieLocalDataSource.Response == MovieEntity,
    RemoteDataSource.Request == Int,
    RemoteDataSource.Response == MovieResponse,
    Transformer.Request == Int,
    Transformer.Response == MovieResponse,
    Transformer.Entity == MovieEntity,
    Transformer.Domain == MovieModel {
    
    public typealias Request = Int
    public typealias Response = MovieModel
    
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
    
    public func execute(request: Int?) -> AnyPublisher<MovieModel, Error> {
        guard let request = request else { fatalError("Request cannot be empty")}
        
        return _localDataSource.get(id: request)
            .map{_mapper.transformEntityToDomain(entity: $0)}
            .eraseToAnyPublisher()
    }
}

public extension GetDetailMovieRepository {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Singleton>) {
            binder.include(module: GetMovieLocalDataSource.Module.self)
            binder.include(module: GetMovieRemoteDataSource.Module.self)
            binder.include(module: MovieTransformer.Module.self)
            binder.bind(GetDetailMovieRepository.self).to(factory: GetDetailMovieRepository.init)
        }
    }
}
