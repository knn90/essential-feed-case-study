//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 25/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation

public protocol FeedImageView: class {
    associatedtype Image
    func display(_ model: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let feedImageView: View
    private let imageTransformer: (Data) -> Image?
    
    public init(feedImageView: View, imageTransformer: @escaping (Data) -> Image?) {
        self.feedImageView = feedImageView
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedImage) {
        feedImageView.display(FeedImageViewModel(
                                description: model.description,
                                location: model.location,
                                image: nil,
                                isLoading: true,
                                shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        let image = imageTransformer(data)
        feedImageView.display(FeedImageViewModel(
                                description: model.description,
                                location: model.location,
                                image: image,
                                isLoading: false,
                                shouldRetry: image == nil))
        
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        feedImageView.display(FeedImageViewModel(
                        description: model.description,
                        location: model.location,
                        image: nil,
                        isLoading: false,
                        shouldRetry: true))
    }
    
    public static func map(_ image: FeedImage) -> FeedImageViewModel<Image> {
        return FeedImageViewModel(
            description: image.description,
            location: image.location,
            image: nil,
            isLoading: false,
            shouldRetry: true)
    }
}
