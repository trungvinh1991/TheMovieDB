//
//  CategoryCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 17/03/2021.
//

import UIKit
import Gradients

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var customLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.layer.cornerRadius = 6
        shadowView.layer.shadowColor = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 0.7).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 5)
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func updateInfo(movie: MovieInfo) {
        self.titleLabel.text = movie.originalTitle
        
        customLayer?.removeFromSuperlayer()
        let customLayer = Gradients.linear(to: .degree(135), colors:[UIColor.random().cgColor, UIColor.random().cgColor, UIColor.random().cgColor, UIColor.random().cgColor], locations: [0.0, 1.0])
        customLayer.frame = self.containerView.bounds
        self.containerView.layer.addSublayer(customLayer)
        self.customLayer = customLayer
        
    }
}
