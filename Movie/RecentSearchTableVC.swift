//
//  RecentSearchTableVC.swift
//  Movie
//
//  Created by Navneet on 4/26/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

protocol RecentSearchProtocol {
    func controller(_ controller: RecentSearchTableVC, didSelectItem item: String?)
}

class RecentSearchTableVC: UITableViewController {

    var delegate: RecentSearchProtocol?
    private var items: [String]?
    private let MAX_ROW = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = UserDefaults.standard.array(forKey: "RecentSearchedMovies") as? [String]
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = items?.count, count < MAX_ROW else { return MAX_ROW }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = items?[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, didSelectItem: items?[indexPath.row])
    }
}
