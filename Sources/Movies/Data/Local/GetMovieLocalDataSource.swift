//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 19/02/21.
//

import Foundation
import Core
import Combine
import RealmSwift

public struct GetMovieLocalDataSource: LocalDataSource {
    
    
    public typealias Request = Int
    
    public typealias Response = MovieEntity
    
    private let _realm: Realm
    
    public init(realm: Realm) {
        _realm = realm
    }
    
    public func list(request: Int?) -> AnyPublisher<[MovieEntity], Error> {
        return Future<[MovieEntity], Error> { completion in
            guard let request = request else { return completion(.failure(DatabaseError.requestFailed))}
            
            let movies: Results<MovieEntity> = {
                _realm.objects(MovieEntity.self)
                    .sorted(byKeyPath: "title", ascending: true)
            }()
            completion(.success(movies.toArray(ofType: MovieEntity.self)))
            
        }.eraseToAnyPublisher()
    }
    
    public func add(entities: [MovieEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write{
                    for movie in entities {
                        _realm.add(movie, update: .all)
                    }
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }
    
    public func get(id: Int) -> AnyPublisher<MovieEntity, Error> {
        return Future<MovieEntity, Error> { completion in
            let movies: Results<MovieEntity> = {
                _realm.objects(MovieEntity.self)
                    .filter("id = \(id)")
            }()
            
            guard let movie = movies.first else {
                completion(.failure(DatabaseError.requestFailed))
                return
            }
            
            completion(.success(movie))
            
        }.eraseToAnyPublisher()
    }
    
    public func update(id: Int, entity: MovieEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let movieEntity = {
                _realm.objects(MovieEntity.self).filter("id = \(id)")
            }().first {
                do {
                    try _realm.write{
                        movieEntity.setValue(entity.id, forKey: "id")
                        movieEntity.setValue(entity.title, forKey: "title")
                        movieEntity.setValue(entity.posterPath, forKey: "posterPath")
                        movieEntity.setValue(entity.backdropPath, forKey: "backdropPath")
                        movieEntity.setValue(entity.voteAverage, forKey: "voteAverage")
                        movieEntity.setValue(entity.overview, forKey: "overview")
                        movieEntity.setValue(entity.releaseDate, forKey: "releaseDate")
                        movieEntity.setValue(entity.favorite, forKey: "favorite")
                    }
                    completion(.success(true))
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    
}
