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
        let cell = FeedImageCell()
        viewModel.onChange = { [weak cell] viewModel in
            cell?.locationContainer.isHidden = (viewModel.locationString == nil)
            cell?.locationLabel.text = viewModel.locationString
            cell?.descriptionLabel.text = viewModel.descriptionString
            cell?.feedImageRetryButton.isHidden = !viewModel.retryActionVisible
            
            if viewModel.isLoading {
                cell?.imageContainer.startShimmering()
            } else {
                cell?.imageContainer.stopShimmering()
            }
            
            let image = viewModel.image
            cell?.feedImageView.image = image
        }
        cell.onRetry = viewModel.loadImageData
        viewModel.loadImageData()
        
        return cell
    }
    
    func preload() {
        self.viewModel.preload()
    }

    func cancelLoad() {
        viewModel.cancelLoad()
    }

}
