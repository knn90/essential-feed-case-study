//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 14/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public enum LoadFeedResult<Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
