//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 21/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

internal final class FeedItemMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            print(data)
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.items
    }
}
