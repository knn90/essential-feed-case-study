//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 1/12/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void)
}

class LocalFeedImageDataLoader: FeedImageDataLoader {
    private final class Task: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping ((FeedImageDataLoader.Result) -> Void)) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletion()
        }
        
        private func preventFurtherCompletion() {
            completion = nil
        }
    }
    
    let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { result in
            task.complete(with:
                result
                    .mapError { _ in Error.failed }
                    .flatMap { data in
                        data.map { .success($0) } ?? .failure(Error.notFound)
                    })
        }
        return task
    }
}

final class LocalFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    func test_loadImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed()) {
            let retrievalError = anyNSError()
            store.complete(with: retrievalError)
        }
    }
    
    func test_loadImageDataFromURL_deliversImageDataOnFoundData() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        expect(sut, toCompleteWith: .success(foundData)) {
            store.complete(with: foundData)
        }
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterCancellingTask() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        
        var received = [FeedImageDataLoader.Result]()
        let task = sut.loadImageData(from: anyURL()) { received.append($0) }
        
        task.cancel()
        
        store.complete(with: foundData)
        store.complete(with: nil)
        store.complete(with: anyNSError())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LocalFeedImageDataLoader, StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func failed() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.failed)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: LocalFeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch(expectedResult, receivedResult) {
            case (.failure, .failure): break
            case let (.success(expectedData), .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, "Expected to get \(expectedData), got \(receivedData) instead", file: file, line: line)
            default:
                XCTFail("Expected to get \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private class StoreSpy: FeedImageDataStore {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        private(set) var receivedMessages = [Message]()
        private var completions = [(FeedImageDataStore.Result) -> Void]()
        
        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receivedMessages.append(.retrieve(dataFor: url))
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
        
        
        func complete(with data: Data?, at index: Int = 0) {
            completions[index](.success(data))
        }
    }
}
