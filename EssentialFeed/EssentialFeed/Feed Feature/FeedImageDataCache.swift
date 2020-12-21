//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 21/12/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
