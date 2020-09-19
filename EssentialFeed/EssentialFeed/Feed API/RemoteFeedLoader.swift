//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 16/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
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
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { (error, response) in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
            
        }
    }
}
