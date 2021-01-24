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
        private let items: [RemoteFeedItem]
        
        private struct RemoteFeedItem: Decodable {
            internal let id: UUID
            internal let description: String?
            internal let location: String?
            internal let image: URL
        }
        
        var images: [FeedImage] {
            return items.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            print(data)
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.images
    }
}

