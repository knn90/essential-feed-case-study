//
//  RemoteLoader.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 24/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation

public final class RemoteLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    public typealias Result = FeedLoader.Result
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemMapper.map(data, response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}