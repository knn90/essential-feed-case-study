//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 23/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
