//
//  SearchViewController.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var txtField: UITextField!

    private enum SegueID: String {
        case Detail = "DetailDegueID"
        case Popover = "PopoverSegueID"
    }
    
    private var searchQuery: String?
    lazy var serviceController: MoviesFetchable = ServiceController()

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
            let destinationVC = segue.destination as? SearchResultsVC
            destinationVC?.viewModel = SearchResultsViewModel(movie: searchQuery, results: sender as? MovieResults)
            
            persistSearchQuery(searchQuery)
            
        case .Popover:
            let recentSearchVC = segue.destination as? RecentSearchVC
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
    
    @IBAction func searchAction() {
       fetchResults(for: txtField.text)
    }
    
    // MARK: - Fetch sesults for the query string
    
    func fetchResults(for queryString: String?) {
        guard let queryString = queryString, !queryString.isEmpty else {
            showOkAlert(with: nil, message: "Enter a movie name")
            return
        }
        
        serviceController.fetch(for: queryString, page: 1) { [weak self] (movieResults, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self?.showOkAlert(with: "Error", message: "Something went wrong")
                } else {
                    guard (movieResults?.movies.count ?? 0) > 0 else {
                        self?.showOkAlert(with: nil, message: "Movie not found, try something else")
                        return
                    }
                    
                    self?.searchQuery = queryString
                    self?.performSegue(withIdentifier: "DetailDegueID", sender: movieResults)
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
    
    fileprivate func persistSearchQuery(_ query: String?) {
        guard let query = query?.lowercased() else { return }
        
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

    func controller(_ controller: RecentSearchVC, didSelectItem item: String?) {
        controller.dismiss(animated: false) {
            self.txtField.text = item
            self.fetchResults(for: item)
        }
    }
}
