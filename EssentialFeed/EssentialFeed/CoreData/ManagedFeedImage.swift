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
}
