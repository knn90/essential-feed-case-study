//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 26/10/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}
