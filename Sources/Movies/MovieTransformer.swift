//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 21/02/21.
//

import Foundation
import Core
import RealmSwift

public struct MovieTransformer: Mapper{
    
    public typealias Entity = MovieEntity
    public typealias Domain = MovieModel
    public typealias Request = Int
    public typealias Response = MovieResponse

    
    public init(){}
    
    public func transformResponseToEntity(request: Int?, response: MovieResponse) -> MovieEntity {
        let movieEntity = MovieEntity()
        
        movieEntity.id = response.id ?? 0
        movieEntity.title = response.title ?? ""
        movieEntity.posterPath = response.posterPath ?? ""
        movieEntity.backdropPath = response.backdropPath ?? ""
        movieEntity.voteAverage = response.voteAverage ?? 0
        movieEntity.overview = response.overview ?? ""
        movieEntity.releaseDate = response.releaseDate ?? ""
        
        return movieEntity
    }
    
    public func transformEntityToDomain(entity: MovieEntity) -> MovieModel {
        return MovieModel(
            id: entity.id,
            title: entity.title,
            posterPath: entity.posterPath,
            voteAverage: entity.voteAverage,
            backdropPath: entity.backdropPath,
            overview: entity.overview,
            releaseDate: entity.releaseDate,
            favorite: entity.favorite
        )
    }

}
