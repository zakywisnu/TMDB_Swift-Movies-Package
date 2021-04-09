//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 06/04/21.
//

import Core

public typealias MovieDetailInteractor = Interactor<Int, MovieModel, GetDetailMovieRepository<GetMovieLocalDataSource,
//                                                                                              GetMovieRemoteDataSource,
                                                                                              MovieTransformer>>
