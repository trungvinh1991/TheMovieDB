//
//  HomeTrendingCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 17/03/2021.
//

import UIKit
import Foundation
import SDWebImage

class HomeTrendingCell: UICollectionViewCell {
    @IBOutlet weak var trendingImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    var shadowLayer: CALayer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        trendingImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        
        shadowView.layer.cornerRadius = 6
        shadowView.layer.shadowColor = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 0.7).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 15)
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 6
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }

    func updateInfo(movie: MovieInfo) {
        let postUrl = MovieDBProvider.poster(movie.backdropPath ?? "")
        trendingImageView.sd_setImage(with: URL(string: postUrl.url))
    }
}
