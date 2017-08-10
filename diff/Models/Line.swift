//
//  Line.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import Foundation

enum LineType {
    case unchanged
    case addition
    case deletion
}

struct Line {
    
    var content = ""
    var lineType = LineType.unchanged
    var lineNumbers = (deleted: 0, added: 0)
}

extension Line {
    
    init?(content: String, lineNumbers:(Int, Int)) {
        self.lineNumbers = lineNumbers
        self.content = content
        
        if content.hasPrefix(" ") {
            self.lineType = .unchanged
        } else if content.hasPrefix("+") {
            self.lineType = .addition
        } else if content.hasPrefix("-") {
            self.lineType = .deletion
        } else {
            return nil
        }
    }
}
