//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 06/04/21.
//

import Core
import Cleanse

public extension GetListPresenter {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Singleton>) {
            binder.include(module: GetListMovieRepository<
                            GetMovieLocalDataSource,
                            GetListMovieRemoteDataSource,
                            MovieListTransformer>.Module.self)
            binder.include(module: GetFavoriteMovieRepository<
                            GetFavoriteLocalDataSource,
                            MovieListTransformer>.Module.self)
            
            binder.bind(MovieListPresenter.self).to{(movieListRepository: Provider<GetListMovieRepository<GetMovieLocalDataSource, GetListMovieRemoteDataSource, MovieListTransformer>>) ->
                MovieListPresenter in
                return MovieListPresenter(useCase: MovieListInteractor(repository: movieListRepository.get()))
            }
            
            binder.bind(FavoriteMoviePresenter.self).to{ (favoriteMovieRepository: Provider<GetFavoriteMovieRepository<GetFavoriteLocalDataSource, MovieListTransformer>>) ->
                FavoriteMoviePresenter in
                return FavoriteMoviePresenter(useCase: FavoriteMovieInteractor(repository: favoriteMovieRepository.get()))
            }
            
        }
    }
}

public extension Presenter {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Singleton>) {
            binder.include(module: GetDetailMovieRepository<
                            GetMovieLocalDataSource,
                            GetMovieRemoteDataSource,
                            MovieTransformer>.Module.self)
            binder.include(module: UpdateFavoriteMovieRepository<
                            GetFavoriteLocalDataSource,
                            MovieTransformer>.Module.self)
            
            binder.bindFactory(MovieDetailPresenter.self).with(MovieDetailPresenter.AssistedFeed.self).to { (detailRepository: Provider<GetDetailMovieRepository<GetMovieLocalDataSource, GetMovieRemoteDataSource, MovieTransformer>>, seed: Assisted<MovieModel>) ->
                MovieDetailPresenter in
                return MovieDetailPresenter(useCase: MovieDetailInteractor(repository: detailRepository.get()), request: seed.get().id)
            }
            
            binder.bind(UpdateFavoriteMoviePresenter.self).to{ (updateRepository: Provider<UpdateFavoriteMovieRepository<GetFavoriteLocalDataSource, MovieTransformer>>) ->
                UpdateFavoriteMoviePresenter in
                return UpdateFavoriteMoviePresenter(useCase: UpdateFavoriteInteractor(repository: updateRepository.get()))
            }
        }
    }
}
