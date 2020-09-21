//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 21/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
