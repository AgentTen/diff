//
//  Service.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import Foundation

enum Result<Model> {
    case success(Model)
    case failure(Error)
}

final class Service {
    func load<Model>(resource: Resource<Model>, completion: @escaping (Result<Model>) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { (data, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                if let data = data {
                    do {
                        let result = try resource.parse(data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
            }.resume()
    }
}
