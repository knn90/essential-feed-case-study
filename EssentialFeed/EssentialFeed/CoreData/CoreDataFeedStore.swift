//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 8/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(name: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (InsertionCompletion)) {
        let context = self.context
        context.perform {
            let set = NSOrderedSet(array: feed.map {
                let managedFeed = ManagedFeedImage(context: context)
                managedFeed.id  = $0.id
                managedFeed.imageDescription = $0.description
                managedFeed.location = $0.location
                managedFeed.url = $0.url
                return managedFeed
            })
            let managedCache = ManagedCache(context: context)
            managedCache.feed = set
            managedCache.timestamp = timestamp
            context.insert(managedCache)
            try! context.save()
            completion(nil)
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            let request = NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
            let caches = try! context.fetch(request)
            if !caches.isEmpty {
                let feed = caches[0].feed
                    .compactMap { $0 as? ManagedFeedImage }
                    .map { LocalFeedImage(id: $0.id,
                                          description: $0.imageDescription,
                                          location: $0.location,
                                          url: $0.url) }
                let timestamp = caches[0].timestamp
                completion(.found(feed: feed, timestamp: timestamp))
            } else {
                completion(.empty)
            }
        }
    }
}

extension  NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    static func load(name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        return container
    }
}

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd")
            .flatMap {
                NSManagedObjectModel(contentsOf: $0)
            }
    }
}
