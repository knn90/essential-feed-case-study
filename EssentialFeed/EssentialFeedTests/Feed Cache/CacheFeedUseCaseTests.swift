//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 21/10/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed

class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_deletesCachedFeed() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueImageFeed().models) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(uniqueImageFeed().models) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }
    
    func test_save_requestsCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        let feed = uniqueImageFeed()
        
        sut.save(feed.models) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(feed.local, timestamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, completeWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
    
        let insertionError = anyNSError()
        
        expect(sut, completeWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, completeWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults: [LocalFeedLoader.SaveResult] = []
        sut?.save(uniqueImageFeed().models) { receivedResults.append($0) }
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults: [LocalFeedLoader.SaveResult] = []
        sut?.save(uniqueImageFeed().models) { receivedResults.append($0) }

        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty) 
    }
    
    //MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (LocalFeedLoader, FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func uniqueImage() -> FeedImage {
        return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    }
    
    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let models = [uniqueImage(), uniqueImage()]
        let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
        
        return (models, local)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0, userInfo: nil)
    }
    
    private func expect(_ sut: LocalFeedLoader, completeWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var receivedError: Error?
        let exp = expectation(description: "Wait for save completion")
        sut.save(uniqueImageFeed().models) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError as NSError?)
    }
    
    private class FeedStoreSpy: FeedStore {
        enum ReceivedMessage: Equatable {
            case deleteCachedFeed
            case insert([LocalFeedImage], Date)
        }
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        private(set) var receivedMessages = [ReceivedMessage]()
        
        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            receivedMessages.append(.deleteCachedFeed)
            deletionCompletions.append(completion)
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (InsertionCompletion)) {
            receivedMessages.append(.insert(feed, timestamp))
            insertionCompletions.append(completion)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }

}