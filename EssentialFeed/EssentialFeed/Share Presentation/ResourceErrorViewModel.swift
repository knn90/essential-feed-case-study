//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 25/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
