//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 19/02/21.
//

import Foundation

public struct MovieModel: Identifiable, Equatable {
    public let id: Int
    public let title: String
    public var posterPath: String
    public var voteAverage: Double
    public var backdropPath: String
    public var overview: String
    public var releaseDate: String
    public var favorite: Bool
}
