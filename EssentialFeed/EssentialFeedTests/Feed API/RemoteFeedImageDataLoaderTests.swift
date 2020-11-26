//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 26/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    init(client: Any) {
        
    }
}

final class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformAnyRequest() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        
        XCTAssertTrue(client.messages.isEmpty)
    }
    
    //MARK: - Helpers
    private class HTTPClientSpy {
        var messages = [Any]()
    }
}
