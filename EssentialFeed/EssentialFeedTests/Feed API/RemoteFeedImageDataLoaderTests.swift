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
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            default: break
            }
        }
    }
}

final class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformAnyRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageData_performsGETRequest() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageDataTwice_performsGETRequestTwice() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        
        sut.loadImageData(from: url) { _ in }
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadImageData_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        
        let exp = expectation(description: "Wait for load completion")
        sut.loadImageData(from: url) { result in
            switch result {
            case .failure: break
            default:
                XCTFail("Expected to get failure, got \(result) instead")
            }
            exp.fulfill()
        }
        
        client.complete(with: anyNSError())
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RemoteFeedImageDataLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var completions = [(HTTPClient.Result) -> Void]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[0](.failure(error))
        }
    }
}
