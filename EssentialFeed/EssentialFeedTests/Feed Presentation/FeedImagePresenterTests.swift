//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 25/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedImagePresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
    
}
