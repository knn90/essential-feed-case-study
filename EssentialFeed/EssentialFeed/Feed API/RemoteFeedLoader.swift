//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 16/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemMapper.map)
    }
}

