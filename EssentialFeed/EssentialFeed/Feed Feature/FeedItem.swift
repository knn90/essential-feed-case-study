//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 14/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
