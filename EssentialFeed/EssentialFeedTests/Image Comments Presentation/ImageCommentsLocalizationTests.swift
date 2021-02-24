//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 24/2/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalisations() {
        let table = "ImageComments"
        let presentationBundle = Bundle(for: ImageCommentsPresenter.self)
        
        assertLocalizedKeyAndValueExist(in: presentationBundle, table)
    }
}
