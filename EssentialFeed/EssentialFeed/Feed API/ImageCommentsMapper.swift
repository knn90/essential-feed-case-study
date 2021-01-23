//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 23/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation

internal final class ImageCommentsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            print(data)
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.items
    }
}
