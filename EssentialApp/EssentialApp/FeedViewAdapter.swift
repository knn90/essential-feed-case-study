//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 21/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    private weak var feedViewController: FeedViewController?
    private var imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(feedViewController: FeedViewController,
         imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.feedViewController = feedViewController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        feedViewController?.display(viewModel.feed.map {
            
            let adapter = FeedImageLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: $0, imageLoader: imageLoader)
            
            let controller = FeedImageCellController(delegate: adapter)
            
            let presenter = FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(feedImageView: WeakRefVirtualProxy(controller),imageTransformer: UIImage.init)
            adapter.presenter = presenter
            return controller
        })

    }
}
