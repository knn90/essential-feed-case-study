//
//  ManagedFeedImage.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 5/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged internal var id: UUID
    @NSManaged internal var imageDescription: String?
    @NSManaged internal var location: String?
    @NSManaged internal var url: URL
    @NSManaged internal var cache: ManagedCache
    
    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map {
            let managedFeed = ManagedFeedImage(context: context)
            managedFeed.id  = $0.id
            managedFeed.imageDescription = $0.description
            managedFeed.location = $0.location
            managedFeed.url = $0.url
            return managedFeed
        })
    }
    
    var local: LocalFeedImage {
        return LocalFeedImage(id: id,
                              description: imageDescription,
                              location: location,
                              url: url)
    }
}
