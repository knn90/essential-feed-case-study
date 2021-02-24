//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 25/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        return FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
