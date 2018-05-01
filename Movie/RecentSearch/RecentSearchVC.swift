//
//  RecentSearchVC.swift
//  Movie
//
//  Created by Navneet on 4/26/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

protocol RecentSearchProtocol {
    func controller(_ controller: RecentSearchVC, didSelectItem item: String?)
}

class RecentSearchVC: UITableViewController {

    var delegate: RecentSearchProtocol?
    let viewModel = RecentSearchTableViewModel()
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.items?.count, count < viewModel.maxRows else { return viewModel.maxRows }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = viewModel.items?[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, didSelectItem: viewModel.items?[indexPath.row])
    }
}
