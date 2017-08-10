//
//  PullRequest.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import Foundation

struct PullRequest {
    
    var number = 0
    var title = ""
    var body = ""
    var diffUrl = ""
    var author = ""
    var createdAt = ""
}

extension PullRequest {
    
    init(json: JSONDictionary) throws {
        guard let number = json["number"] as? Int else {
            throw SerializationError.missing("number")
        }
        guard let title = json["title"] as? String else {
            throw SerializationError.missing("title")
        }
        guard let body = json["body"] as? String else {
            throw SerializationError.missing("body")
        }
        guard let diffUrl = json["diff_url"] as? String else {
            throw SerializationError.missing("diff_url")
        }
        guard let user = json["user"] as? [String: Any] else {
            throw SerializationError.missing("user")
        }
        guard let author = user["login"] as? String else {
            throw SerializationError.missing("login")
        }
        guard let createdAt = json["created_at"] as? String else {
            throw SerializationError.missing("created_at")
        }
        
        self.number = number
        self.title = title
        self.body = body
        self.diffUrl = diffUrl
        self.author = author
        self.createdAt = createdAt
    }
}

extension PullRequest {
    static let all = Resource<[PullRequest]>(url: URL(string: "https://api.github.com/repos/magicalpanda/MagicalRecord/pulls")!, parseJSON: { json in
        guard let dictionaries = json as? [JSONDictionary] else { throw SerializationError.missing("pullRequests") }
        return try dictionaries.map(PullRequest.init)
    })
}
