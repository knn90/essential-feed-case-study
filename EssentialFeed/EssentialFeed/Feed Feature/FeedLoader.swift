//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 14/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
