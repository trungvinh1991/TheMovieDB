//
//  VideosCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit

class VideosCell: UITableViewCell {
    static let commonSize = CGSize(width: 200, height: 140)
    static let padding: CGFloat = 16
    static let interItemSpacing: CGFloat = 16
    
    @IBOutlet weak var collectionView: UICollectionView!
    var videos: [VideoInfo] = [VideoInfo]()
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
        layout.itemSize = CGSize(width: VideosCell.commonSize.width, height: VideosCell.commonSize.height)
        layout.sectionInset = UIEdgeInsets(top: 15, left: VideosCell.padding, bottom: 0, right: VideosCell.padding)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = VideosCell.interItemSpacing
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: String(describing: VideoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: VideoCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func reset(videos: [VideoInfo], loadMore: Bool = false) {
        if loadMore {
            self.videos.append(contentsOf: videos)
        } else {
            self.videos = videos
        }
        self.collectionView.reloadData()
    }
}

extension VideosCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoCell.self), for: indexPath) as? VideoCell else {
            fatalError()
        }
        cell.updateInfo(video: videos[indexPath.row])
        return cell
    }
}
