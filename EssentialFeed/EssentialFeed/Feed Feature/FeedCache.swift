//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 20/12/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
