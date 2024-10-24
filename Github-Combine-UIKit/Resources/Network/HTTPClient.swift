//
//  HTTPClient.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 07/08/2024.
//

import Combine
import Foundation

enum NetworkError: Error {
    case badUrl
}

class HTTPClient {
    
    func fetchUser(search: String) -> AnyPublisher<User, Error> {
        
        guard let encodedSearch = search.urlEncoded,
              let url = URL(string: "https://api.github.com/users/\(encodedSearch)") else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: User.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .catch { error -> AnyPublisher<User, Error> in
                    return Fail(error: error).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
    }
}
