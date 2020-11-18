//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 16/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

final class FeedImageCellController {
    private let viewModel: FeedImageCellViewModel
    
    init(viewModel: FeedImageCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view() -> FeedImageCell {
        let cell = binded(FeedImageCell())
        viewModel.loadImageData()
        return cell
    }
    
    private func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            if isLoading {
                cell?.feedImageContainer.startShimmering()
            } else {
                cell?.feedImageContainer.stopShimmering()
            }
        }
        viewModel.onShouldRetryImageLoadingStateChange = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }
        
        return cell
    }
    
    func preload() {
        self.viewModel.preload()
    }

    func cancelLoad() {
        viewModel.cancelLoad()
    }

}
