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
    lazy var serviceController: Fetchable = ServiceController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
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
        guard let path = path else {
            self.posterImgView.image = viewModel?.defaultImage
            return
        }
        
        hideSpinner(false)
        
        let params = PosterImageParams(path: path)
        serviceController.download(with: params, completion: { [weak self] (image, error) in
            DispatchQueue.main.async {
                self?.hideSpinner(true)
                
                guard let image = image else {
                    self?.posterImgView.image = self?.viewModel?.defaultImage
                    return
                }
                
                self?.viewModel?.imageCache?.setObject(image, forKey: path as NSString)
                self?.posterImgView.image = image
            }
        })
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        releaseDateLabel.text = nil
        overviewLabel.text = nil
        posterImgView.image = nil
        activityIndicator.isHidden = true
    }
}
