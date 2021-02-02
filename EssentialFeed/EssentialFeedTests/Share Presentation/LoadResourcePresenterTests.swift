//
//  LoadResourcePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 2/2/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed
    
class LoadResourcePresenterTests: XCTestCase {
    
    func test_init_doesNotSendAnyMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoading_displayNoErrorMessageAndStartLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingFeed_displayFeedAndStopLoading() {
        let (sut, view) = makeSUT()
        let feed = uniqueImageFeed().models
        
        sut.didFinishLoadingFeed(with: feed)
        
        XCTAssertEqual(view.messages, [
            .display(feed: feed),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingFeed_displayLocalizedErrorMessageAndStopLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingFeed(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("FEED_VIEW_CONNECTION_ERROR")),
            .display(isLoading: false)
        ])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LoadResourcePresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(feedView: view, loadingView: view, errorView: view)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        
        return (sut, view)
    }
    private class ViewSpy: FeedErrorView, FeedLoadingView, FeedView {
        private(set) var messages = Set<Message>()
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(feed: [FeedImage])
        }
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: FeedViewModel) {
            messages.insert(.display(feed: viewModel.feed))
        }
    }
    
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: LoadResourcePresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key), in table \(table)", file: file, line: line)
        }
        return value
    }
}
