//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 19/02/21.
//

import Foundation

public struct MovieListResponse: Codable {
    let results: [MovieResponse]
}

public struct MovieResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case overview = "overview"
    }
    
    let id: Int?
    let title: String?
    let voteAverage: Double?
    let posterPath: String?
    let releaseDate: String?
    let backdropPath: String?
    let overview: String?
}
