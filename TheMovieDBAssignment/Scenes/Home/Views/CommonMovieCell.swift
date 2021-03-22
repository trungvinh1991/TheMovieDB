//
//  CommonMovieCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 17/03/2021.
//

import UIKit
import SDWebImage

class CommonMovieCell: UICollectionViewCell {

    @IBOutlet weak var commonImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 0.75).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 20)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }

    func updateInfo(movie: MovieInfo) {
        titleLabel.isHidden = movie.isRefreshControl
        detailButton.isHidden = movie.isRefreshControl
        commonImageView.isHidden = movie.isRefreshControl
        indicatorView.isHidden = !movie.isRefreshControl
        if movie.isRefreshControl {
            indicatorView.startAnimating()
        } else {
            let postUrl = MovieDBProvider.poster(movie.posterPath ?? "")
            commonImageView.sd_setImage(with: URL(string: postUrl.url),
                                        placeholderImage: nil,
                                        options: .refreshCached,
                                        context: nil)
            titleLabel.text = movie.originalTitle
        }
        
    }
}
