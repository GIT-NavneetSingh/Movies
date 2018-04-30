//
//  SearchResultsVC.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

class SearchResultsVC: UITableViewController {
    
    var viewModel: SearchResultsViewModel?
    
    private var currentPage: Int = 1
    private var isLoading = false

    lazy var serviceController: MoviesFetchable = ServiceController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.title
    }

    deinit {
        viewModel?.removeAllCachedImages()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.movies?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self), for: indexPath)

        // Configure the cell...
        if let cell = cell as? SearchResultsTableViewCell {
            cell.viewModel = SearchResultCellViewModel(movie: viewModel?.movies?[indexPath.section], cache: viewModel?.cache)
            cell.configureView()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            indexPath.section == (viewModel?.movies?.count ?? 0) - 1,
            currentPage < (viewModel?.totalPages ?? 0),
            !isLoading
            else { return }
        
        currentPage += 1
        isLoading = true
        
        fetchResults(for: viewModel?.movie, page: currentPage)
    }
    
    // MARK: - Fetch results
    
    private func fetchResults(for queryString: String?, page: Int) {
        guard let queryString = queryString else { return }
        serviceController.fetch(for: queryString, page: page) { [weak self] (movieResults, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let movies = movieResults?.movies, !movies.isEmpty else {
                    self?.currentPage -= 1
                    return
                }
                
                self?.viewModel?.appendMovieResults(movies)
                self?.tableView.reloadData()
            }
        }
    }
}
