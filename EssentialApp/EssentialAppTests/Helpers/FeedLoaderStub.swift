//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Khoi Nguyen on 20/12/20.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
