//
//  SearchResultsVC.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

class SearchResultsVC: UITableViewController {
    
    var viewModel: SearchResultsTableViewModel?
    private let cache = NSCache<NSString, UIImage>()
    private var isLoading = false
    lazy var serviceController: MoviesFetchable = ServiceController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.title
    }

    deinit {
        cache.removeAllObjects()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.movies.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self), for: indexPath)

        // Configure the cell...
        if let cell = cell as? SearchResultsTableViewCell {
            cell.viewModel = SearchResultCellViewModel(movie: viewModel?.movies[indexPath.section], cache: cache)
            cell.configureView()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let viewModel = viewModel,
            indexPath.section == viewModel.movies.count - 1,
            viewModel.currentPage < viewModel.totalPages,
            !isLoading
            else { return }
        
        fetchResults(for: viewModel.movie,
                     page: viewModel.currentPage + 1,
                     completion: { [weak self] in
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
        })
    }
    
    // MARK: - Fetch results
    
    private func fetchResults(for queryString: String?, page: Int, completion: @escaping () -> ()) {
        guard let queryString = queryString  else { return }
        isLoading = true
        serviceController.fetch(for: queryString, page: page) { [weak self] (movieResults, error) in
            self?.isLoading = false
            self?.viewModel?.processMovieResults(movieResults)
            completion()
        }
    }
}
