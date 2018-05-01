//
//  SearchResultsTableViewCell.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SearchResultCellViewModel?
    lazy var serviceController: DataDownloadable = ServiceController()
    
    func configureView() {
        titleLabel.text = viewModel?.title
        releaseDateLabel.text = viewModel?.releaseDate
        overviewLabel.text = viewModel?.overview
        
        guard let image = viewModel?.image else {
            fetchImage(from: viewModel?.posterPath)
            return
        }
        
        posterImgView.image = image
    }
    
    fileprivate func hideSpinner(_ hide: Bool) {
        activityIndicator.isHidden = hide
        if hide {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    private func fetchImage(from path: String?) {
        hideSpinner(false)
        viewModel?.getImage { [weak self] image in
            DispatchQueue.main.async {
                self?.hideSpinner(true)
                self?.posterImgView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        releaseDateLabel.text = nil
        overviewLabel.text = nil
        posterImgView.image = nil
        activityIndicator.isHidden = true
    }
}
