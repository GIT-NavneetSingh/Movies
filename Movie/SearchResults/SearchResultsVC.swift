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
    
    private var dataSource: [Movie] = []
    private var currentPage: Int = 1
    private var isLoading = false
    private var cache = NSCache<AnyObject, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.movie?.uppercased()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self), for: indexPath) as? SearchResultsTableViewCell

        // Configure the cell...
        cell?.viewModel = SearchResultCellViewModel(movie: dataSource[indexPath.section], cache: cache)
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
        
        fetchResults(for: viewModel?.movie, page: currentPage)
    }
    
    // MARK: - Fetch results
    
    func fetchResults(for queryString: String?, page: Int, serviceController: MoviesFetchable = ServiceController()) {
        guard
            let queryString = queryString,
            let encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(encodedQueryString)&page=\(page)") else { return }
        
        serviceController.fetch(url) { [weak self] (results, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let movies = results?.movies, !movies.isEmpty else {
                    self?.currentPage -= 1
                    return
                }
                self?.dataSource.append(contentsOf: movies)
                self?.tableView.reloadData()
            }
        }
    }
}