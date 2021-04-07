//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 06/04/21.
//

import Core
import Cleanse

public typealias MovieDetailPresenter = Presenter<Int, MovieModel, MovieDetailInteractor>

public extension MovieDetailPresenter {
    struct AssistedFeed: AssistedFactory {
        public typealias Seed = MovieModel
        public typealias Element = MovieDetailPresenter
    }
}
