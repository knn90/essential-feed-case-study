//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 15/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedItemMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemMapper.map(json, HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalidJSON".utf8)
        
        XCTAssertThrowsError(
            try FeedItemMapper.map(invalidJSON, HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliverSuccessOn200HTTPResponseWithEmptyList() throws {
        let emptyListData = makeItemJSON([])

        let result = try FeedItemMapper.map(emptyListData, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])

    }
    
    func test_map_deliverSuccessWithItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://a-url.com")!)
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "http://another-url.com")!)
        let json = makeItemJSON([item1.json, item2.json])
        
        let result = try FeedItemMapper.map(json, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    //MARK: - Helpers
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(
            id: id,
            description: description,
            location: location,
            url: imageURL)
        
        let itemJSON: [String: Any] = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return (item, itemJSON)
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
