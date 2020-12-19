//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Khoi Nguyen on 19/12/20.
//

import Foundation

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyData() -> Data {
    return Data("any data".utf8)
}
