//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Khoi Nguyen on 21/12/20.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            
            completion(result.map { data in
                self?.cache.save(data, for: url, completion: { _ in })
                return data
            })
        }
    }
}
