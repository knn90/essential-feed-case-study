//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 22/12/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let needFrameUpdate = header.frame.height != size.height
        if needFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
