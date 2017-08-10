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
    
    init?(json: [String: Any]) {
        guard let number = json["number"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String,
            let diffUrl = json["diff_url"] as? String,
            let user = json["user"] as? [String: Any],
            let author = user["login"] as? String,
            let createdAt = json["created_at"] as? String
            else {
                return nil
        }
        
        self.number = number
        self.title = title
        self.body = body
        self.diffUrl = diffUrl
        self.author = author
        self.createdAt = createdAt
    }
}
