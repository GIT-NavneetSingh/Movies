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
        case detail = "DetailSegueID"
        case popover = "PopoverSegueID"
    }
    
    private enum ErrorMessage: String {
        case emptyQuery = "Please enter a movie name & search again."
        case serverError = "Sorry, we have a technical problem at the moment. Please try again later."
        case emptyResults = "Sorry, we did not find this movie in our database, please try some other movie."
    }
    
    var viewModel = SearchViewModel(title: "Search", searchQuery: "")
    lazy var serviceController: Fetchable = ServiceController()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        title = viewModel.title
        txtField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let segueID = SegueID(rawValue: identifier) else { return }
        
        switch segueID {
        case .detail:
            guard let results = sender as? MovieResults else { return }
            let destinationVC = segue.destination as? SearchResultsVC
            destinationVC?.viewModel = SearchResultsTableViewModel(movie: viewModel.searchQuery, results: results)
            
        case .popover:
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
        
        performSegue(withIdentifier: SegueID.popover.rawValue, sender: sender)
    }
    
    @IBAction func searchAction() {
        getResults(for: txtField.text)
    }
    
    // MARK: - Show/Hide spinner
    fileprivate func hideSpinner(_ hide: Bool) {
        if hide {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }

        activityIndicatorView.isHidden = hide
        activityIndicator.isHidden = hide
    }
    
    // MARK: - Fetch sesults for the query string
    fileprivate func getResults(for queryString: String?) {
        txtField.resignFirstResponder()

        guard let queryString = queryString, !queryString.isEmpty else {
            showOkAlert(with: nil, message: .emptyQuery)
            return
        }
        
        fetchResults(for: queryString) { [weak self] (movieResults, errorMsg) in
            guard errorMsg == nil, let movieResults = movieResults else {
                self?.showOkAlert(with: nil, message: errorMsg)
                return
            }
            
            self?.viewModel.persistSearchQuery(queryString)
            self?.performSegue(withIdentifier: SegueID.detail.rawValue, sender: movieResults)
        }
    }
    
    private func fetchResults(for queryString: String, completion: @escaping (_: MovieResults?, _ errorMessage: ErrorMessage?) -> ()) {
        hideSpinner(false)
        let params = MovieParams(query: queryString, page: 1)
        serviceController.fetch(with: params, completion: { [weak self] (movieResults, error) in
            DispatchQueue.main.async {
                
                self?.hideSpinner(true)
                
                guard error == nil else {
                    completion(nil, .serverError)
                    return
                }
                
                guard let movies = movieResults?.movies, movies.count > 0 else {
                    completion(nil, .emptyResults)
                    return
                }
                
                completion(movieResults, nil)
            }
        })
    }
    
    // MARK: - Show alert
    private func showOkAlert(with title: String?, message: ErrorMessage?) {
        let alert = UIAlertController(title: title, message: message?.rawValue, preferredStyle: .alert)
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
            self.getResults(for: item)
        }
    }
}
