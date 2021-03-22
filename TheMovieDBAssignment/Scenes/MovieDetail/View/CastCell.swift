//
//  CastCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit
import SDWebImage

class CastCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        castImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 0.75).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        
    }

    func updateInfo(cast: CastInfo) {
        let url = MovieDBProvider.poster(cast.profilePath ?? "")
        castImageView.sd_setImage(with: URL(string: url.url),
                                 placeholderImage: nil,
                                 options: .refreshCached,
                                 context: nil)
        self.nameLabel.text = cast.originalName
        self.positionLabel.text = cast.knownForDepartment
    }
}
