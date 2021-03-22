//
//  RecommendationsCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit

class RecommendationsCell: UITableViewCell {
    static let padding: CGFloat = 16
    static let interItemSpacing: CGFloat = 14
    static let commonSize = CGSize(width: 100, height: 210)
    
    var movies = [MovieInfo]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.configCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: RecommendationsCell.commonSize.width, height: RecommendationsCell.commonSize.height)
        layout.sectionInset = UIEdgeInsets(top: 15, left: RecommendationsCell.padding, bottom: 0, right: RecommendationsCell.padding)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = RecommendationsCell.interItemSpacing
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: String(describing: RecommendationCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: RecommendationCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func reset(movies: [MovieInfo], loadMore: Bool = false) {
        if loadMore {
            self.movies.append(contentsOf: movies)
        } else {
            self.movies = movies
        }

        self.collectionView.reloadData()
    }
}

extension RecommendationsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecommendationCell.self), for: indexPath) as? RecommendationCell else {
            fatalError()
        }
        cell.updateInfo(movie: movies[indexPath.row])
        return cell
    }
}
