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

public struct GetFavoriteLocalDataSource: LocalDataSource {
    
    public typealias Request = Int
    
    public typealias Response = MovieEntity
    
    private let _realm: Realm
    
    public init(realm: Realm) {
        _realm = realm
    }
    
    public func list(request: Int?) -> AnyPublisher<[MovieEntity], Error> {
        return Future<[MovieEntity], Error> { completion in
            let movieEntities = {
                _realm.objects(MovieEntity.self)
                    .filter("favorite = \(true)")
                    .sorted(byKeyPath: "title", ascending: true)
            }()
            completion(.success(movieEntities.toArray(ofType: MovieEntity.self)))
        }.eraseToAnyPublisher()
    }
    
    public func add(entities: [MovieEntity]) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
    
    public func get(id: Int) -> AnyPublisher<MovieEntity, Error> {
        return Future<MovieEntity, Error> { completion in
            if let movieEntity = {
                _realm.objects(MovieEntity.self).filter("id = \(id)")
            }().first {
                do {
                    try _realm.write {
                        movieEntity.setValue(!movieEntity.favorite, forKey: "favorite")
                    }
                    completion(.success(movieEntity))
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    public func update(id: Int, entity: MovieEntity) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
    
}
