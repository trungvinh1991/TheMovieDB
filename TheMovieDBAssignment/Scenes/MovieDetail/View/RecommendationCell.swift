//
//  RecommendationCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit
import SDWebImage

class RecommendationCell: UICollectionViewCell {
    @IBOutlet weak var recImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 0.75).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        
        recImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
    }
    
    func updateInfo(movie: MovieInfo) {
        let postUrl = MovieDBProvider.poster(movie.posterPath ?? "")
        recImageView.sd_setImage(with: URL(string: postUrl.url),
                                 placeholderImage: nil,
                                 options: .refreshCached,
                                 context: nil)
        titleLabel.text = movie.originalTitle
    }
}
