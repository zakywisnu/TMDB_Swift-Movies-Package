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

public struct GetListMovieRemoteDataSource: DataSource {
    public typealias Request = Int
    public typealias Response = [MovieResponse]
    private let _endpoint: String
    
    public init(endpoint: String){
        _endpoint = endpoint
    }
    
    public func execute(request: Request?) -> AnyPublisher<Response, Error> {
        return Future<[MovieResponse], Error> { completion in
            
            if let url = URL(string: _endpoint) {
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
