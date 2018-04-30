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
    
    func configureView() {
        titleLabel.text = viewModel?.title
        releaseDateLabel.text = viewModel?.releaseDate
        overviewLabel.text = viewModel?.overview
        
        setImage()
    }
    
    fileprivate func setImage() {
        guard let path = viewModel?.posterPath else { return }
        
        if let cachedData = viewModel?.cache.object(forKey: path as AnyObject) as? Data {
            activityIndicator.isHidden = true
            posterImgView.image = UIImage(data: cachedData)
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            fetchImage(from: path)
        }
    }
    
    func fetchImage(from path: String?, serviceController: DataDownloadable = ServiceController()) {
        guard
            let path = path,
            let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://image.tmdb.org/t/p/w92\(encodedPath)") else {
                return
        }
        
        serviceController.download(url) { [weak self] data in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                
                guard let data = data, let image = UIImage(data: data) else { return }
                
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
