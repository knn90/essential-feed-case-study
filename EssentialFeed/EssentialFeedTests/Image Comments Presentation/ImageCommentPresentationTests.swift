//
//  ImageCommentPresentationTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 24/2/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentPresentationTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
    func test_map_createsViewModels() {
        let now = Date()
        let comments = [
            ImageComment(
                id: UUID(),
                message: "a message",
                createAt: now.adding(minutes: -5),
                username: "a username"),
            ImageComment(
                id: UUID(),
                message: "another message",
                createAt: now.adding(days: -1),
                username: "another username")
        ]
        
        let viewModel = ImageCommentsPresenter.map(comments)
        
        XCTAssertEqual(viewModel.comments, [
            ImageCommentViewModel(
                message: "a message",
                date: "5 minutes ago",
                username: "a username"
            ),
            ImageCommentViewModel(
                message: "another message",
                date: "1 day ago",
                username: "another username"
            )
        ])
    }
    
    //MARK: - Helpers
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key), in table \(table)", file: file, line: line)
        }
        return value
    }
}