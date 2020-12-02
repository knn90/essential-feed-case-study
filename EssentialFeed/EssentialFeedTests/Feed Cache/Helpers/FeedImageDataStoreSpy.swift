//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 2/12/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }
    
    private(set) var receivedMessages = [Message]()
    
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    private var insertionCompletions = [(FeedImageDataStore.InsertionResult) -> Void]()
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(data: data, for: url))
    }
    func complete(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func complete(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](.success(()))
    }
}
