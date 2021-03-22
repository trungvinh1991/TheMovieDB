//
//  CastsCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit

class CastsCell: UITableViewCell {
    static let commonSize = CGSize(width: 70, height: 180)
    static let padding: CGFloat = 16
    static let interItemSpacing: CGFloat = 14
    
    @IBOutlet weak var collectionView: UICollectionView!
    var casts: [CastInfo] = [CastInfo]()

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
        layout.itemSize = CGSize(width: CastsCell.commonSize.width, height: CastsCell.commonSize.height)
        layout.sectionInset = UIEdgeInsets(top: 15, left: CastsCell.padding, bottom: 0, right: CastsCell.padding)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CastsCell.interItemSpacing
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: String(describing: CastCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CastCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func reset(casts: [CastInfo]) {
        self.casts = casts

        self.collectionView.reloadData()
    }
}

extension CastsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastCell.self), for: indexPath) as? CastCell else {
            fatalError()
        }
        cell.updateInfo(cast: casts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CastsCell.commonSize.width, height: CastsCell.commonSize.height)
    }
}
