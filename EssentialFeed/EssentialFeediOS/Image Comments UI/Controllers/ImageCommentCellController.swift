//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 25/2/21.
//  Copyright © 2021 Khoi Nguyen. All rights reserved.
//

import Foundation
import EssentialFeed
import UIKit

public class ImageCommentCellController: CellController {
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueResuableCell()
        cell.messageLabel.text = model.message
        cell.dateLabel.text = model.date
        cell.usernameLabel.text = model.username
        
        return cell
    }
    
    public func preload() {
        
    }
    
    public func cancelLoad() {
        
    }
    
    
}
