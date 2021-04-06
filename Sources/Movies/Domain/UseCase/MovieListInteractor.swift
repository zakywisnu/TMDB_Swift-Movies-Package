//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 06/04/21.
//

import Core

public typealias MovieListInteractor = Interactor<Int, [MovieModel], GetListMovieRepository<GetMovieLocalDataSource, GetListMovieRemoteDataSource, MovieListTransformer>>
