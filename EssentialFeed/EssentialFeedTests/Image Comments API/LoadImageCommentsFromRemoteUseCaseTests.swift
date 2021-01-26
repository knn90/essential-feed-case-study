//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 23/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 150, 300, 400, 500]
        
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: failure(.invalidData), when: {
                let data = makeItemJSON([])
                client.complete(withStatusCode: code, data: data, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let samples = [200, 201, 250, 280, 299]
        
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: failure(.invalidData), when: {
                let invalidJSON = Data("invalidJSON".utf8)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            })
        }
    }
    
    func test_load_deliverSuccessOn2xxHTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT()
        
        let samples = [200, 201, 250, 280, 299]
        
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: .success([]), when: {
                let emptyListData = makeItemJSON([])
                client.complete(withStatusCode: code, data: emptyListData, at: index)
            })
        }
    }
    
    func test_load_deliverSuccessWithItemsOn2xxHTTPResponseWithJSONItems() {
        
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
        
        let (sut, client) = makeSUT()
        
        let samples = [200, 201, 250, 280, 299]
        
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: .success([item1.model, item2.model]), when: {
                let json = makeItemJSON([item1.json, item2.json])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        
        return (sut, client)
    }
    
    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
    
    private func expect(_ sut: RemoteImageCommentsLoader, toCompleteWithResult expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedFailure as RemoteImageCommentsLoader.Error)):
                XCTAssertEqual(receivedError, expectedFailure, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
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
