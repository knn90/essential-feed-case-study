//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 25/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
