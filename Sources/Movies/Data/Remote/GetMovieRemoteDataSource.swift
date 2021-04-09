//
//  File.swift
//  
//
//  Created by Ahmad Zaky on 19/02/21.
//

import Cleanse
import Core
import Combine
import Alamofire
import Foundation

public struct GetMovieRemoteDataSource: DataSource {
    public typealias Request = Int
    public typealias Response = MovieResponse
    
    
    public func execute(request: Request?) -> AnyPublisher<Response, Error> {
        return Future<MovieResponse, Error> { completion in
            guard let _request = request else { return completion(.failure(URLError.invalidRequest))}
            
            if let url = URL(string: "\(API.baseUrl)3/movie/\(_request)?api_key=c3141d1a29379bd03dceb243cd2a5942") {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: MovieResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}

extension GetMovieRemoteDataSource {
    struct Module: Cleanse.Module {
        static func configure(binder: Binder<Singleton>) {
            binder.bind(GetMovieRemoteDataSource.self).to(factory: GetMovieRemoteDataSource.init)
        }
    }
}
