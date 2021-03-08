//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 16/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import Combine

public final class CommentsUIComposer {
    private init() {}
    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentViewAdapter>
    public static func commentsComposedWith(
        commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
    ) -> ListViewController {
        
        let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)
        let commentsViewController = makeCommentsViewController(title: ImageCommentsPresenter.title)
        commentsViewController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentViewAdapter(commentsViewController),
            loadingView: WeakRefVirtualProxy(commentsViewController),
            errorView: WeakRefVirtualProxy(commentsViewController),
            mapper: { ImageCommentsPresenter.map($0) })
        return commentsViewController
    }
    
    private static func makeCommentsViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyBoard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyBoard.instantiateInitialViewController() as! ListViewController
        controller.title = title
        return controller
    }
}

final class CommentViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(_ controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}
