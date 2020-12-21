//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Khoi Nguyen on 21/12/20.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_init_doesNotLoadImageData() {
        let (_, imageLoader) = makeSUT()
        
        XCTAssertTrue(imageLoader.messages.isEmpty)
    }
    
    func test_loadImageData_loadsFromLoader() {
        let (sut, imageLoader) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: anyURL()) { _ in }
        
        XCTAssertEqual(imageLoader.loadedURLs, [url], "Expected to load url from loader")
    }
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        let (sut, imageLoader) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(imageLoader.cancelledURLs, [url], "Expected to cancel URL Loading from loader")
    }
    
    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let imageData = anyData()
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .success(imageData), when: {
            loader.complete(with: imageData)
        })
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            loader.complete(with: anyNSError())
        })
    }
    
    func test_loadImageData_cachesLoadedDataOnLoaderSuccess() {
        let cache = CacheSpy()
        let (sut, loader) = makeSUT(cache: cache)
        let url = anyURL()
        let data = anyData()
        _ = sut.loadImageData(from: url) { _ in }
        loader.complete(with: data)
        XCTAssertEqual(cache.messages, [.save(data, for: url)], "Expected to save data on loader success")
    }
    
    func test_loadImageData_doesNotCacheDataOnLoaderFailure() {
            let cache = CacheSpy()
            let url = anyURL()
            let (sut, loader) = makeSUT(cache: cache)

            _ = sut.loadImageData(from: url) { _ in }
            loader.complete(with: anyNSError())

            XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache image data on load error")
        }
    
    // MARK: - Helpers
    private func makeSUT(cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy) {
        let imageLoader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: imageLoader, cache: cache)
        
        trackForMemoryLeaks(imageLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(cache, file: file, line: line)
        return (sut, imageLoader)
    }
    
    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(Data, for: URL)
        }
        
        func save(_ data: Data, for url: URL, completion: (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data, for: url))
            completion(.success(()))
        }
    }
}
