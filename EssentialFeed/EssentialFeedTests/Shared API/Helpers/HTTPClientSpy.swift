//
//  HTTPClientSpy.swift
//  EssentialFeedTests
//
//  Created by Khoi Nguyen on 28/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import EssentialFeed

class HTTPClientSpy: HTTPClient {
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    var cancelledURLs = [URL]()
    
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        let task = Task(callback: { [weak self] in
            self?.cancelledURLs.append(url)
        })
        return task
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!
        messages[index].completion(.success((data, response)))
    }
}

