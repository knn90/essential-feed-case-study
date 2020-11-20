//
//  FeedImageCellViewModel.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 18/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//
import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
