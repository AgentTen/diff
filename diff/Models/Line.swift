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

extension Line {
    
    static func parsePatch(patch: String) -> [Line] {
        let components = patch.components(separatedBy: .newlines)
        var contentFound = false
        
        var changes = [Line]()
        var lineNumbers = (deleted: 0, added: 0)
        
        for string in components {
            if string.hasPrefix("@@") {
                contentFound = true
                lineNumbers = parseLineNumbers(string: string)
                continue
            }
            if contentFound {
                if let line = Line(content: string, lineNumbers: lineNumbers) {
                    changes.append(line)
                    if line.lineType == .deletion {
                        lineNumbers.deleted += 1
                    } else if line.lineType == .addition {
                        lineNumbers.added += 1
                    } else {
                        lineNumbers = (lineNumbers.deleted + 1, lineNumbers.added + 1)
                    }
                }
            }
        }
        return changes
    }
    
    private static func parseLineNumbers(string: String) -> (Int, Int) {
        return (findDelValue(string: string), findAddValue(string: string))
    }
    
    private static func findDelValue(string: String) -> Int {
        return findValue(string: string, pattern: "-(.*?),")
    }
    
    private static func findAddValue(string: String) -> Int {
        return findValue(string: string, pattern: "\\+(.*?),")
    }
    
    private static func findValue(string: String, pattern: String) -> Int {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        let tmp = string as NSString
        var results = [String]()
        
        regex.enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.characters.count)) { result, flags, stop in
            if let range = result?.rangeAt(1) {
                results.append(tmp.substring(with: range))
            }
        }
        
        return Int(results[0]) ?? 0
    }
}
