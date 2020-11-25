//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 25/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {}
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendAnyMessageToView() {
        let view = ViewSpy()
        let _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    private class ViewSpy {
        var messages = [Any]()
    }
}
