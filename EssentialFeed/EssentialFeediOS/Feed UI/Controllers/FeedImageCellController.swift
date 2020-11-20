//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 16/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

final class FeedImageCellController: NSObject, FeedImageView {
    private let presenter: FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>
    private lazy var view: FeedImageCell = FeedImageCell()
    
    init(presenter: FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>) {
        self.presenter = presenter
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
    }
    
    func loadView() -> FeedImageCell {
        
        view.onRetry = presenter.loadImageData
        presenter.loadImageData()
        return view
    }
    
    func preload() {
        presenter.preload()
    }

    func cancelLoad() {
        presenter.cancelLoad()
    }

}
