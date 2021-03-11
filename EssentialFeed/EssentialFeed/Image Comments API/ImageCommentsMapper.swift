//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 23/1/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation

public final class ImageCommentsMapper {
    private struct Root: Decodable {
        private let items: [Item]
        
        private struct Item: Decodable {
            let id: UUID
            let message: String
            let created_at: Date
            let author: Author
        }
        
        private struct Author: Decodable {
            let username: String
        }
        
        var comments: [ImageComment] {
            return items.map {
                ImageComment(id: $0.id, message: $0.message, createAt: $0.created_at, username: $0.author.username)
            }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [ImageComment] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard isOK(response), let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }

        return root.comments
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        return (200...299).contains(response.statusCode)
    }
}
