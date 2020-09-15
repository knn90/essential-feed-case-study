//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 15/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoader {
    
}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    
}
