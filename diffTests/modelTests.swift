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
