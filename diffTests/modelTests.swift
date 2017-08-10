//
//  diffTests.swift
//  diffTests
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import XCTest
@testable import diff

class modelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitPullFromJSON() {
        
        let pull = try! PullRequest(json: pullRequestDict())
        
        XCTAssertEqual(pull.number, 123)
        XCTAssertEqual(pull.title, "test pull")
        XCTAssertEqual(pull.body, "test body")
        XCTAssertEqual(pull.diffUrl, "http://")
        XCTAssertEqual(pull.createdAt, "2017-05-20T10:07:40Z")
        XCTAssertEqual(pull.author, "Ryan")
        
        var badDict = pullRequestDict()
        badDict["user"] = nil
        
        do {
            _ = try PullRequest(json: badDict)
        }
        catch let e as SerializationError {
            XCTAssertEqual(e, SerializationError.missing("user"))
        }
        catch {
            XCTFail("Wrong error")
        }
    }
    
    func pullRequestDict() -> JSONDictionary {
        return [
            "number": 123,
            "title": "test pull",
            "body": "test body",
            "diff_url": "http://",
            "created_at": "2017-05-20T10:07:40Z",
            "user": [
                "login": "Ryan"
            ]
        ]
    }
    
    func testInitFileFromJSON() {
        let file = try! File(json: fileDict())
        
        XCTAssertEqual(file.filename, "filename")
        XCTAssertEqual(file.patch, " these are a bunch of changes")
        
        var badDict = fileDict()
        badDict["patch"] = nil
        
        do {
            _ = try File(json: badDict)
        }
        catch let err as SerializationError {
            XCTAssertEqual(err, SerializationError.missing("patch"))
        }
        catch {
            XCTFail("Wrong error")
        }
    }
    
    func fileDict() -> [String: Any] {
        return [
            "filename": "filename",
            "patch": " these are a bunch of changes"
        ]
    }
    
    func testInitLines() {
        let unchanged = Line(content: " nothing changes", lineNumbers: (1,1))
        
        XCTAssertEqual(unchanged?.lineType, .unchanged)
        XCTAssertEqual(unchanged?.lineNumbers.deleted, 1)
        XCTAssertEqual(unchanged?.lineNumbers.added, 1)
        
        let deleted = Line(content: "-this went away", lineNumbers: (1,2))

        XCTAssertEqual(deleted?.lineType, .deletion)
        XCTAssertEqual(deleted?.lineNumbers.deleted, 1)
        XCTAssertEqual(deleted?.lineNumbers.added, 2)

        let added = Line(content: "+this showed up"
            , lineNumbers: (2,1))

        XCTAssertEqual(added?.lineType, .addition)
        XCTAssertEqual(added?.lineNumbers.deleted, 2)
        XCTAssertEqual(added?.lineNumbers.added, 1)

        let badLine = Line(content: "***", lineNumbers: (0,0))
        XCTAssertNil(badLine)
    }
    
    func testParsePatchIntoLines() {
        let lines = Line.parsePatch(patch: patch())
        
        XCTAssertEqual(lines.count, 10)
        XCTAssertEqual(lines[0].lineType, .unchanged)
        XCTAssertEqual(lines[1].content, " ")
        XCTAssertEqual(lines[2].content, "         } while (!convertedValue && dateFormat);")
        XCTAssertEqual(lines[3].lineType, .deletion)
        XCTAssertEqual(lines[4].lineType, .addition)
        XCTAssertEqual(lines[5].lineType, .addition)
        XCTAssertEqual(lines[6].lineNumbers.added, 51)
        XCTAssertEqual(lines[6].lineNumbers.deleted, 50)
        XCTAssertEqual(lines[7].lineNumbers.added, 52)
        XCTAssertEqual(lines[7].lineNumbers.deleted, 50)
        XCTAssertEqual(lines[8].lineNumbers.added, 53)
        XCTAssertEqual(lines[8].lineNumbers.deleted, 51)
        XCTAssertEqual(lines[9].content, " }")
        
        let noLines = Line.parsePatch(patch: " ")
        XCTAssertEqual(noLines.count, 0)
    }
    
    func patch() -> String {
        return "@@ -46,7 +46,9 @@ - (NSDate *)MR_dateValueForKeyPath:(NSString *)keyPath fromObjectData:(id)object\n             convertedValue = [value MR_dateWithFormat:dateFormat];\n \n         } while (!convertedValue && dateFormat);\n-        value = convertedValue;\n+        if(convertedValue!=nil){\n+            value = convertedValue;\n+        }\n     }\n     return value;\n }"
    }
}
