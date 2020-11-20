//
//  FeedImageCellViewModel.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 18/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//
import EssentialFeed

protocol FeedImageView: class {
    associatedtype Image
    
    func display(_ viewModel: FeedImageViewModel<Image>)
}

class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private let feedImageView: View
    private let imageTransformer: (Data) -> Image?
    
    
    init(feedImageView: View, imageTransformer: @escaping (Data) -> Image?) {
        self.feedImageView = feedImageView
        self.imageTransformer = imageTransformer
    }
    
    func didStartLoadingImage(for model: FeedImage) {
        feedImageView.display(FeedImageViewModel<Image>(
                                description: model.description,
                                location: model.location,
                                image: nil,
                                isLoading: true,
                                shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        feedImageView.display(FeedImageViewModel<Image>(
                                description: model.description,
                                location: model.location,
                                image: image,
                                isLoading: false,
                                shouldRetry: false))
    }
    
    private struct InvalidImageDataError: Error {}
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        feedImageView.display(FeedImageViewModel<Image>(
                                description: model.description,
                                location: model.location,
                                image: nil,
                                isLoading: false,
                                shouldRetry: true))
    }
}
