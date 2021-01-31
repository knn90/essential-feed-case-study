//
//  FeedImageDataMapper.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 31/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation

public class FeedImageDataMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
