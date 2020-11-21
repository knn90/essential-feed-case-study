//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 16/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let feedViewController = FeedViewController.makeWith(
            delegate: presentationAdapter,
            title: FeedPresenter.title)
        presentationAdapter.feedPresenter = FeedPresenter(
            loadingView: WeakRefVirtualProxy(feedViewController),
            feedView: FeedViewAdapter(
                feedViewController: feedViewController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)))
        return feedViewController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyBoard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyBoard.instantiateInitialViewController() as! FeedViewController
        feedViewController.delegate = delegate
        feedViewController.title = FeedPresenter.title
        return feedViewController
    }
}
