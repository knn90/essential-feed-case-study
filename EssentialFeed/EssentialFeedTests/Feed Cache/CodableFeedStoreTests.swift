//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 28/10/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed

class CodableFeedStore {
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage) {
            self.id = image.id
            self.description = image.description
            self.location = image.location
            self.url = image.url
        }
        
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let storeURL:URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let cache = try! JSONDecoder().decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (FeedStore.InsertionCompletion)) {
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let data = try! JSONEncoder().encode(cache)
        try! data.write(to: storeURL)
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()
        
        let exp = expectation(description: "Wait for retrieval completion")
        sut.insert(feed.local, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieve: .found(feed: feed.local, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()
        let exp = expectation(description: "Wait for retrieval completion")
        sut.insert(feed.local, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieveTwice: .found(feed: feed.local, timestamp: timestamp))
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        
        let sut = CodableFeedStore(storeURL: testSpecificStoreURL())
        
        trackForMemoryLeaks(sut)
        
        return sut
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult: RetrievalCacheFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieval completion")
        
        sut.retrieve() { retrievedResult in
            switch (retrievedResult, expectedResult) {
            case (.empty, .empty): break
            case let (.found(retrievedFeed, retrievedTimestamp), .found(expectedFeed, expectedTimestamp)):
                XCTAssertEqual(retrievedFeed, expectedFeed)
                XCTAssertEqual(retrievedTimestamp, expectedTimestamp)
            default:
                XCTFail("Expected to get \(expectedResult), got \(retrievedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieveTwice expectedResult: RetrievalCacheFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}
