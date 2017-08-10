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
    var status = ""
    var additions = 0
    var deletions = 0
    var changes = 0
    var lines = [Line]()
}

extension File {
    
    init?(json: [String: Any]) {
        guard let filename = json["filename"] as? String,
            let status = json["status"] as? String,
            let additions = json["additions"] as? Int,
            let deletions = json["deletions"] as? Int,
            let changes = json["changes"] as? Int,
            let patch = json["patch"] as? String
            else {
                return nil
        }
        
        self.filename = filename
        self.status = status
        self.additions = additions
        self.deletions = deletions
        self.changes = changes
        self.lines = tempLines() //patch
    }
    
    func tempLines() -> [Line] {
        let unchanged = Line(content: " nothing changes", lineNumbers: (1,1))!
        let deleted = Line(content: "-this went away", lineNumbers: (2,2))!
        let added = Line(content: "+this showed up"
            , lineNumbers: (2,2))!
        return [unchanged, deleted, added]
    }
}
