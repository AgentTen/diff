//
//  Resource.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import Foundation

enum SerializationError: Error, Equatable {
    case missing(String)
}

func ==(lhs: SerializationError, rhs: SerializationError) -> Bool {
    switch (lhs, rhs) {
    case (.missing(let leftMessage), .missing(let rightMessage)):
        return leftMessage == rightMessage
    }
}

typealias JSONDictionary = [String : Any]

struct Resource<Model> {
    let url: URL
    let parse: (Data) throws -> Model
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any) throws -> Model) {
        self.url = url
        self.parse = { data in
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return try parseJSON(json)
        }
    }
}
