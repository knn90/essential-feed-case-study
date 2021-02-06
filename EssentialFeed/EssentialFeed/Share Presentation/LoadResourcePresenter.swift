//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 2/2/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation
public protocol ResourceView {
    func display(_ viewModel: String)
}
public class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    private let resourceView: ResourceView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    private let mapper: Mapper
    
    public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedErrorViewModel.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

}
