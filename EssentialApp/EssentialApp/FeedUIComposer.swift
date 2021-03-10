//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 16/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import Combine

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }) -> ListViewController {
        
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(loader: feedLoader)
        let feedViewController = makeFeedViewController(title: FeedPresenter.title)
        feedViewController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                feedViewController: feedViewController,
                imageLoader: imageLoader,
                selection: selection),
            loadingView: WeakRefVirtualProxy(feedViewController),
            errorView: WeakRefVirtualProxy(feedViewController),
            mapper: FeedPresenter.map)
        return feedViewController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyBoard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyBoard.instantiateInitialViewController() as! ListViewController
        feedViewController.title = title
        return feedViewController
    }
}
