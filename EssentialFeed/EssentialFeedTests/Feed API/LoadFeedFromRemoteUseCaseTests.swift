//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 15/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: failure(.invalidData), when: {
                let data = makeItemJSON([])
                client.complete(withStatusCode: code, data: data, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: failure(.invalidData), when: {
            let invalidJSON = Data("invalidJSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliverSuccessOn200HTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListData = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyListData)
        })
    }
    
    func test_load_deliverSuccessWithItemsOn200HTTPResponseWithJSONItems() {
        
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://a-url.com")!)
        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "http://another-url.com")!)
        
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([item1.model, item2.model]), when: {
            let json = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        
        return (sut, client)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithResult expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedFailure as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedFailure, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
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
