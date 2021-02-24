//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Khoi Nguyen on 24/2/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation


public final class ImageCommentsPresenter {
    
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: ImageCommentsPresenter.self),
                                 comment: "Title for the image comments view")
    }
}
