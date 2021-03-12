//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 12/3/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
}
