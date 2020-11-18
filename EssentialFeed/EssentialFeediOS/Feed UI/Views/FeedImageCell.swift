//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 15/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import UIKit

public final class FeedImageCell: UITableViewCell {
    public var locationContainer = UIView()
    public var locationLabel = UILabel()
    public var descriptionLabel = UILabel()
    public var feedImageContainer = UIView()
    public var feedImageView = UIImageView()
    
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapAction), for: .touchUpInside)
        return button
    }()
    
    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapAction() {
        onRetry?()
    }
}
