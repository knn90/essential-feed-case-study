//
//  FeedImageDataMapperTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 31/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedImageDataMapperTests: XCTestCase {
    func test_map_throwsInvalidDataErrorOnNon200HTTPResponse() throws {
        try [199, 201, 300, 400, 500].forEach { statusCode in
            XCTAssertThrowsError(
                try FeedImageDataMapper.map(anyData(), HTTPURLResponse(statusCode: statusCode))
            )
        }
    }
    
    func test_loadImageData_deliverInvalidDataOn200HTTPResponseWithEmptyData() throws {
        XCTAssertThrowsError(
            try FeedImageDataMapper.map(Data(), HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_loadImageData_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty data".utf8)
        
        let result = try FeedImageDataMapper.map(nonEmptyData, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, nonEmptyData)
    }
    
    //MARK: - Helpers
}
