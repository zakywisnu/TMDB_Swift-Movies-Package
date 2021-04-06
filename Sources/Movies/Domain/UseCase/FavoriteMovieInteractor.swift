//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 06/04/21.
//

import Core

public typealias FavoriteMovieInteractor = Interactor<Int, [MovieModel], GetFavoriteMovieRepository<GetFavoriteLocalDataSource, MovieListTransformer>>
