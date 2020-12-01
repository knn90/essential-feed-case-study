//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 1/12/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void)
}
