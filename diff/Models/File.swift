//
//  File.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import Foundation

struct File {
    
    var filename = ""
    var patch = ""
    var lines = [Line]()
}

extension File {
    
    init(json: JSONDictionary) throws {
        guard let filename = json["filename"] as? String else {
            throw SerializationError.missing("filename")
        }
        guard let patch = json["patch"] as? String else {
            throw SerializationError.missing("patch")
        }
        
        self.filename = filename
        self.patch = patch
        self.lines = Line.parsePatch(patch: patch)
    }
}

extension File {
    static func all(pullNumber: Int) -> Resource<[File]> {
        let all = Resource<[File]>(url: URL(string: "https://api.github.com/repos/magicalpanda/MagicalRecord/pulls/\(pullNumber)/files")!, parseJSON: { json in
            guard let dictionaries = json as? [JSONDictionary] else { throw SerializationError.missing("files") }
            return try dictionaries.map(File.init)
        })
        return all
    }
}
