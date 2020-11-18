//
//  FeedImageCellViewModel.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 18/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import EssentialFeed

class FeedImageCellViewModel {
    let model: FeedImage
    let imageLoader: FeedImageDataLoader
    var task: FeedImageDataLoaderTask?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    var image: UIImage? {
        switch state {
        case let .loaded(image): return image
        default: return nil
        }
    }
    
    var isLoading: Bool {
        return state == .loading
    }
    
    var locationString: String? {
        return model.location
    }
    
    var descriptionString: String? {
        return model.description
    }
    
    var retryActionVisible: Bool {
        return state == .failed
    }
    
    enum State: Equatable {
        case pending
        case loading
        case loaded(UIImage)
        case failed
    }
    
    private var state: State = .pending {
        didSet {
            onChange?(self)
        }
    }
    
    var onChange: ((FeedImageCellViewModel) -> Void)?
    
    func loadImageData() {
        state = .loading
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            if let data = try? result.get(), let image = UIImage(data: data) {
                self?.state = .loaded(image)
            } else {
                self?.state = .failed
            }
        }
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.url) { _ in }
    }
    
    func cancelLoad() {
        task?.cancel()
    }
}
