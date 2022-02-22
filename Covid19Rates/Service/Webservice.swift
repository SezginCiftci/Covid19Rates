//
//  Webservice.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 7.02.2022.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
}

struct Resource<T: Codable> {
    let url: URL
}

struct Webservice {
    
    
    func fetchData<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> ()) {
        
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
            
            guard let response = response as? HTTPURLResponse  else {
                completion(.failure(.domainError))
                return
            }
            print("Response status code: \(response.statusCode)")
            
        }.resume()
    }
}
