//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Khoi Nguyen on 21/11/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueResuableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return self.dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
