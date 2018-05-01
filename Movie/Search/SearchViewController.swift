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
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private enum SegueID: String {
        case Detail = "DetailDegueID"
        case Popover = "PopoverSegueID"
    }
    
    var viewModel = SearchViewModel(title: "Search", searchQuery: "")
    lazy var serviceController: MoviesFetchable = ServiceController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = viewModel.title
        txtField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let segueID = SegueID(rawValue: identifier) else { return }
        
        switch segueID {
        case .Detail:
            guard let results = sender as? MovieResults else { return }
            let destinationVC = segue.destination as? SearchResultsVC
            destinationVC?.viewModel = SearchResultsTableViewModel(movie: viewModel.searchQuery, results: results)
            
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
    
    fileprivate func hideSpinner(_ hide: Bool) {
        if hide {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }

        activityIndicatorView.isHidden = hide
        activityIndicator.isHidden = hide
    }
    
    func fetchResults(for queryString: String?) {
        txtField.resignFirstResponder()

        guard let queryString = queryString, !queryString.isEmpty else {
            showOkAlert(with: nil, message: "Enter a movie name")
            return
        }
        
        hideSpinner(false)
        
        serviceController.fetch(for: queryString, page: 1) { [weak self] (movieResults, error) in
            DispatchQueue.main.async {
                
                self?.hideSpinner(true)
                
                if error != nil {
                    self?.showOkAlert(with: "Error", message: "Something went wrong")
                } else {
                    guard let movies = movieResults?.movies, movies.count > 0 else {
                        self?.showOkAlert(with: nil, message: "Movie not found, try something else")
                        return
                    }
                    
                    self?.viewModel.persistSearchQuery(queryString)
                    self?.performSegue(withIdentifier: "DetailDegueID", sender: movieResults)
                }
            }
        }
    }
    
    // MARK: - Show alert

    private func showOkAlert(with title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
