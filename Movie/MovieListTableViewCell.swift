//
//  MovieListTableViewCell.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import UIKit

public typealias DownloadBlocks = (_ data: NSData?) -> ()

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: CellViewModel?
    
    func configureView() {
        titleLabel.text = viewModel?.movie.title
        releaseDateLabel.text = viewModel?.movie.releaseDate
        overviewLabel.text = viewModel?.movie.overview
        
        setImage()
    }
    
    fileprivate func setImage() {
        guard let path = viewModel?.movie.posterPath else { return }
        
        if let cachedData = viewModel?.cache.object(forKey: path as AnyObject) as? Data {
            activityIndicator.isHidden = true
            posterImgView.image = UIImage(data: cachedData)
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            viewModel?.fetchImage(from: path, completion: { [weak self] data in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.posterImgView.image = UIImage(data: data as Data? ?? Data())
                    self?.viewModel?.cache.setObject(data as AnyObject, forKey: path as AnyObject)
                }
            })
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
