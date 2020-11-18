//
//  FeedRefreshViewModel.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 17/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {

    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var loadingView: FeedLoadingView?
    var feedView: FeedView?
    
    func loadFeed() {
        loadingView?.display(isLoading: true)
        
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
