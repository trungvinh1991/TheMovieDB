//
//  VideoCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.layer.cornerRadius = 6
        shadowView.layer.shadowColor = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 0.7).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 15)
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 6
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func updateInfo(video: VideoInfo) {
        let postUrl = MovieDBProvider.poster(video.posterPath ?? "")
        videoImageView.sd_setImage(with: URL(string: postUrl.url))
    }
}
