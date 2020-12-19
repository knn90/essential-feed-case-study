//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Khoi Nguyen on 19/12/20.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    private let primaryLoader: FeedImageDataLoader
    private let fallbackLoader: FeedImageDataLoader
    
    public init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primaryLoader = primary
        self.fallbackLoader = fallback
    }
    
    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primaryLoader.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                task.wrapped = self?.fallbackLoader.loadImageData(from: url, completion: completion)
            }
        }
        return task
    }
}
