//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 12/3/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//
import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
