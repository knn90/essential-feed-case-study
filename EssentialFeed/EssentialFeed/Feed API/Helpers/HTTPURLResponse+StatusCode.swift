//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 29/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
