//
//  Helpers.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 13/10/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential meomory leak.", file: file, line: line)
        }
    }
}



