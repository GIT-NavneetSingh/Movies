//
//  SearchViewController.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    private enum SegueID: String {
        case Detail = "DetailDegueID"
        case Popover = "PopoverSegueID"
    }
    
    private var searchQuery = ""

    lazy var engine: NetworkEngine = {
        return NetworkEngine()
    }()
    
    @IBOutlet weak var txtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Search"
        txtField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let segueID = SegueID(rawValue: identifier) else { return }
        
        switch segueID {
        case .Detail:
            let destinationVC = segue.destination as? MovieListTableVC
            destinationVC?.viewModel = MovieListViewModel(movie: searchQuery, results: sender as? Results)
            
            persistSearchQuery(searchQuery)
            
        case .Popover:
            let recentSearchVC = segue.destination as? RecentSearchTableVC
            recentSearchVC?.delegate = self
            recentSearchVC?.popoverPresentationController?.delegate = self
            recentSearchVC?.popoverPresentationController?.sourceView = sender as? UIView // button
            recentSearchVC?.popoverPresentationController?.sourceRect = (sender as? UIView)?.bounds ?? CGRect.zero
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func didTouchDownTextField(_ sender: UITextField) {
        guard
            let list = UserDefaults.standard.array(forKey: "RecentSearchedMovies") as? [String],
            !list.isEmpty
            else { return }
        
        performSegue(withIdentifier: "PopoverSegueID", sender: sender)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        guard let queryString = txtField.text, !queryString.isEmpty else {
            showOkAlert(with: nil, message: "Enter a movie name")
            return
        }
        
        fetchResults(for: queryString)
    }
    
    // MARK: - Fetch sesults for the query string
    
    fileprivate func fetchResults(for queryString: String?) {
        guard
            let queryString = queryString,
            let encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(encodedQueryString)&page=1")
            else {
                return
        }
        
        searchQuery = queryString

        engine.fetch(url) { [weak self] (results, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self?.showOkAlert(with: "Error", message: "Something went wrong")
                } else {
                    guard (results?.movies.count ?? 0) > 0 else {
                        self?.showOkAlert(with: nil, message: "Movie not found, try something else")
                        return
                    }
                    
                    self?.performSegue(withIdentifier: "DetailDegueID", sender: results)
                }
            }
        }
    }
    
    // MARK: - Show alert

    private func showOkAlert(with title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Persist Searches
    
    fileprivate func persistSearchQuery(_ query: String) {
        let userDefault = UserDefaults.standard
        if var list = userDefault.array(forKey: "RecentSearchedMovies") as? [String] {
            if let index = list.index(of: query) {
                list.remove(at: index)
            }
            
            list.insert(query, at: 0)
            userDefault.set(list, forKey: "RecentSearchedMovies")
            userDefault.synchronize()
        } else {
            userDefault.set([query], forKey: "RecentSearchedMovies")
            userDefault.synchronize()
        }
    }
}

// MARK: - Textfield delegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - UIPopover presentation delegate

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Recent search delegate

extension SearchViewController: RecentSearchProtocol {

    func controller(_ controller: RecentSearchTableVC, didSelectItem item: String?) {
        controller.dismiss(animated: true) {
            self.fetchResults(for: item)
        }
    }
}
