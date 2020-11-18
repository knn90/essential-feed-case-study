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
    typealias Observer<T> = (T) -> Void
    let model: FeedImage
    let imageLoader: FeedImageDataLoader
    var task: FeedImageDataLoaderTask?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    var onImageLoad: (Observer<UIImage>)?
    var onImageLoadingStateChange: (Observer<Bool>)?
    var onShouldRetryImageLoadingStateChange: (Observer<Bool>)?
    
    var location: String? {
        return model.location
    }
    
    var hasLocation: Bool {
        return model.location != nil
    }
    
    var description: String? {
        return model.description
    }
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadingStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result: result)
        }
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.url) { _ in }
    }
    
    func cancelLoad() {
        task?.cancel()
    }
    
    private func handle(result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            self.onImageLoad?(image)
        } else {
            self.onShouldRetryImageLoadingStateChange?(true)
        }
        self .onImageLoadingStateChange?(false)
    }
}
