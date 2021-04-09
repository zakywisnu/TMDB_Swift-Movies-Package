//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 19/02/21.
//

import Foundation
import Core
import Combine
import Alamofire
import Cleanse

public struct GetListMovieRemoteDataSource: DataSource {
    public typealias Request = Int
    public typealias Response = [MovieResponse]
   
    
    
    public func execute(request: Request?) -> AnyPublisher<Response, Error> {
        return Future<[MovieResponse], Error> { completion in
            
            if let url = URL(string: "\(API.baseUrl)3/movie/popular?api_key=c3141d1a29379bd03dceb243cd2a5942") {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: MovieListResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
extension GetListMovieRemoteDataSource {
    struct Module: Cleanse.Module {
        static func configure(binder: Binder<Singleton>) {
            binder.bind(GetListMovieRemoteDataSource.self).to(factory: GetListMovieRemoteDataSource.init)
        }
    }
}
