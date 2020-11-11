//
//  FeedVewController.swift
//  Prototype
//
//  Created by Khoi Nguyen on 11/11/20.
//

import UIKit

struct FeedImageViewModel {
    var description: String?
    var location: String?
    var imageName: String
}

final class FeedViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FeedImageCell")!
    }
}
