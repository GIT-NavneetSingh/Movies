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
        
        setImage()
    }
    
    private func setImage() {
        guard let path = viewModel?.posterPath else {
            posterImgView.image = #imageLiteral(resourceName: "default_image")
            return
        }
        
        if let cachedData = viewModel?.cache.object(forKey: path as AnyObject) as? Data {
            activityIndicator.isHidden = true
            posterImgView.image = UIImage(data: cachedData)
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            fetchImage(from: path)
        }
    }
    
    private func fetchImage(from path: String) {
        serviceController.downloadImage(from: path) { [weak self] data in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                
                guard let data = data, let image = UIImage(data: data) else {
                    self?.posterImgView.image = #imageLiteral(resourceName: "default_image")
                    return
                }
                
                self?.posterImgView.image = image
                self?.viewModel?.cache.setObject(data as AnyObject, forKey: path as AnyObject)
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
