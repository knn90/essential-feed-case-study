//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 13/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import UIKit
import EssentialFeed

public final class FeedViewController: UITableViewController {
    
    private var loader: FeedLoader?
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
