//
//  FeedImageCellViewModel.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 18/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView: class {
    associatedtype Image
    func display(_ viewModel: FeedImageViewModel<Image>)
}

class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    private var task: FeedImageDataLoaderTask?
    var feedImageView: View?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    func loadImageData() {
        feedImageView?.display(FeedImageViewModel<Image>(
                                description: model.description,
                                location: model.location,
                                image: nil,
                                isLoading: true,
                                shouldRetry: false))
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
        
        let image = (try? result.get()).flatMap(imageTransformer)
        
        feedImageView?.display(FeedImageViewModel<Image>(
                                description: model.description,
                                location: model.location,
                                image: image,
                                isLoading: false,
                                shouldRetry: image == nil))
    }
}
