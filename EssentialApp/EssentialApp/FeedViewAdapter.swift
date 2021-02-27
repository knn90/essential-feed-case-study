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
    private weak var feedViewController: ListViewController?
    private var imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(feedViewController: ListViewController,
         imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.feedViewController = feedViewController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        feedViewController?.display(viewModel.feed.map { model in
            let adapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>(loader: { [imageLoader] in imageLoader(model.url)
            })
            
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: { data in
                    guard let image = UIImage(data: data) else {
                        throw InvalidImageData()
                    }
                    return image
                })

            return CellController(view)
        })

    }
}

private struct InvalidImageData: Error {}
