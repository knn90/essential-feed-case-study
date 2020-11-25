//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 21/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import EssentialFeed

final class FeedViewAdapter: FeedView {
    private weak var feedViewController: FeedViewController?
    private var imageLoader: FeedImageDataLoader
    
    init(feedViewController: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.feedViewController = feedViewController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        feedViewController?.tableModel = viewModel.feed.map {
            
            let adapter = FeedImageLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: $0, imageLoader: imageLoader)
            
            let controller = FeedImageCellController(delegate: adapter)
            
            let presenter = FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(feedImageView: WeakRefVirtualProxy(controller),imageTransformer: UIImage.init)
            adapter.presenter = presenter
            return controller
        }

    }
}
