//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 26/10/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

internal final class FeedCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    
    private init() {}
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let cacheMaxAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < cacheMaxAge
    }
    
}
