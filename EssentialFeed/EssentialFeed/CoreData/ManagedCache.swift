//
//  ManagedCache.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 5/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
    @NSManaged internal var timestamp: Date
    @NSManaged internal var feed: NSOrderedSet
    
    var localFeed: [LocalFeedImage] {
        feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
}
