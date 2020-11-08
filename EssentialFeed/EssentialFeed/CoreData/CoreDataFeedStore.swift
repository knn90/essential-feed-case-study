//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 8/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

class CoreDataFeedStore: FeedStore {
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (InsertionCompletion)) {
        
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}
