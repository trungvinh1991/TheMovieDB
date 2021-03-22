//
//  ReviewCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit
import SDWebImage
import SwiftyStarRatingView

class ReviewCell: UITableViewCell {
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateInfo(review: ReviewInfo) {
        let ratingValue: Double = Double(review.authorDetail?.rating ?? 0)
        var urlString: String? = review.authorDetail?.avatarPath
        if urlString?.first == "/" {
            urlString?.removeFirst()
        }        
        authorImageView.sd_setImage(with: URL(string: urlString ?? ""),
                                 placeholderImage: nil,
                                 options: .refreshCached,
                                 context: nil)
        self.nameLabel.text = review.authorDetail?.username
        self.contentLabel.text = review.content
        self.ratingLabel.text = String(ratingValue)
        self.ratingView.value = CGFloat(ratingValue)
    }
    
}
