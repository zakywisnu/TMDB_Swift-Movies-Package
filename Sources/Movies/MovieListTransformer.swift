//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 19/02/21.
//

import Foundation
import Core
import RealmSwift
import Cleanse

public struct MovieListTransformer: Mapper{
    
    public typealias Entity = [MovieEntity]
    public typealias Domain = [MovieModel]
    public typealias Request = Int
    public typealias Response = [MovieResponse]
    
    
    public init(){}
    
    public func transformResponseToEntity(request: Int?, response: [MovieResponse]) -> [MovieEntity] {
        return response.map{ result in
            let newMovie = MovieEntity()
            newMovie.id = result.id ?? 0
            newMovie.title = result.title ?? ""
            newMovie.posterPath = result.posterPath ?? ""
            newMovie.backdropPath = result.backdropPath ?? ""
            newMovie.overview = result.overview ?? ""
            newMovie.voteAverage = result.voteAverage ?? 0
            newMovie.releaseDate = result.releaseDate ?? ""
            return newMovie
        }
    }
    
    public func transformEntityToDomain(entity: [MovieEntity]) -> [MovieModel] {
        return entity.map{ result in
            return MovieModel(
                id: result.id,
                title: result.title,
                posterPath: result.posterPath,
                voteAverage: result.voteAverage,
                backdropPath: result.backdropPath,
                overview: result.overview,
                releaseDate: result.releaseDate,
                favorite: result.favorite
            )
        }
        
    }
}

public extension MovieListTransformer {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Singleton>) {
            binder.bind(MovieListTransformer.self).to(factory: MovieListTransformer.init)
        }
    }
}
