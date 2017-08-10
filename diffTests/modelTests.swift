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
        let pull = PullRequest(json: pullRequestDict())
        
        XCTAssertEqual(pull?.number, 123)
        XCTAssertEqual(pull?.title, "test pull")
        XCTAssertEqual(pull?.body, "test body")
        XCTAssertEqual(pull?.diffUrl, "http://")
        XCTAssertEqual(pull?.createdAt, "2017-05-20T10:07:40Z")
        XCTAssertEqual(pull?.author, "Ryan")
        
        var badDict = pullRequestDict()
        badDict["user"] = nil
        
        let badPull = PullRequest(json: badDict)
        XCTAssertNil(badPull)
    }
    
    func testInitFileFromJSON() {
        let file = File(json: fileDict())
        
        XCTAssertEqual(file?.filename, "filename")
        XCTAssertEqual(file?.status, "status")
        XCTAssertEqual(file?.additions, 2)
        XCTAssertEqual(file?.deletions, 3)
        XCTAssertEqual(file?.changes, 4)
        XCTAssertEqual(file?.patch, "these are a bunch of changes")
        
        var badDict = fileDict()
        badDict["filename"] = nil
        
        let badFile = PullRequest(json: badDict)
        XCTAssertNil(badFile)
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
    
    func fileDict() -> [String: Any] {
        return [
            "filename": "filename",
            "status": "status",
            "additions": 2,
            "deletions": 3,
            "changes": 4,
            "patch": "these are a bunch of changes"
        ]
    }
    
    func pullRequestDict() -> [String: Any] {
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
}
