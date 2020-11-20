//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 16/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: NSObject, FeedImageView {
    private lazy var view: FeedImageCell = FeedImageCell()
    private let delegate: FeedImageCellControllerDelegate
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        view.locationContainer.isHidden = !viewModel.hasLocation
        view.locationLabel.text = viewModel.location
        view.descriptionLabel.text = viewModel.description
        view.feedImageView.image = viewModel.image
        if viewModel.isLoading {
            view.feedImageContainer.startShimmering()
        } else {
            view.feedImageContainer.stopShimmering()
        }
        view.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        view.onRetry = delegate.didRequestImage
    }
    
    func loadView() -> FeedImageCell {
        delegate.didRequestImage()
        return view
    }
    
    func preload() {
        delegate.didRequestImage()
    }

    func cancelLoad() {
        delegate.didCancelImageRequest()
    }

}
