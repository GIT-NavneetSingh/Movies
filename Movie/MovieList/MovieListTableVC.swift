//
//  MovieListTableVC.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

class MovieListTableVC: UITableViewController {
    
    var viewModel: MovieListViewModel?
    var dataSource: [Movie] = []
    var currentPage: Int = 1
    var isLoading = false
    var cache = NSCache<AnyObject, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.movie.uppercased()
        dataSource = viewModel?.results?.movies ?? []
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieListTableViewCell.self), for: indexPath) as? MovieListTableViewCell

        // Configure the cell...
        cell?.viewModel = MovieListTableCellViewModel(movie: dataSource[indexPath.section], cache: cache)
        cell?.configureView()
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == dataSource.count - 1,
            currentPage < (viewModel?.results?.totalPages ?? 0),
            !isLoading
            else { return }
        
        currentPage += 1
        isLoading = true
        
        viewModel?.loadPage(currentPage, completion: { [weak self] (results, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let movies = results?.movies else {
                    self?.currentPage -= 1
                    return
                }
                self?.dataSource.append(contentsOf: movies)
                self?.tableView.reloadData()
            }
        })
    }
}
