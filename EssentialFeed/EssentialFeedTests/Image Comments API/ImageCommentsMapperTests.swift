//
//  ImageCommentsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 23/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
    
    func test_maps_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemJSON([])
        
        let samples = [199, 150, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalidJSON".utf8)
        
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(invalidJSON, HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsSuccessOn2xxHTTPResponseWithEmptyList() throws {
        let emptyListData = makeItemJSON([])
        
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyListData, HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [])
        }
    }
    
    func test_map_deliverSuccessWithItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username")
        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createAt: (Date(timeIntervalSince1970: 1610238262), "2021-01-10T00:24:22+00:00"),
            username: "another username")
        let json = makeItemJSON([item1.json, item2.json])
        
        let samples = [200, 201, 250, 280, 299]
        
        try samples.enumerated().forEach { (index, code) in
            let result = try ImageCommentsMapper.map(json, HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [item1.model, item2.model])
        }
    }

    //MARK: - Helpers
    private func makeItem(id: UUID, message: String, createAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(
            id: id,
            message: message,
            createAt: createAt.date,
            username: username)
        
        let itemJSON: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "create_at": createAt.iso8601String,
            "author": [
                "username": username
            ]   
        ]
        
        return (item, itemJSON)
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
}
