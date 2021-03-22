//
//  MovieDetailCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit
import SwiftyStarRatingView
import SDWebImage

class MovieDetailCell: UITableViewCell {
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backDropImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateInfo(movie: MovieInfo) {
        let backUrl = MovieDBProvider.poster(movie.backdropPath ?? "")
        let postUrl = MovieDBProvider.poster(movie.posterPath ?? "")
        let rating = movie.voteAverage ?? 0
        backDropImageView.sd_setImage(with: URL(string: backUrl.url),
                                      placeholderImage: nil,
                                      options: .refreshCached,
                                      context: nil)
        
        posterImageView.sd_setImage(with: URL(string: postUrl.url),
                                      placeholderImage: nil,
                                      options: .refreshCached,
                                      context: nil)
        titleLabel.text = movie.originalTitle
        contentLabel.text = movie.overview
        ratingLabel.text = String(rating)
        ratingView.value = CGFloat(rating)
    }
}
