//
//  ReviewsCell.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import UIKit

class ReviewsCell: UITableViewCell {
    static let height: CGFloat = 400

    @IBOutlet weak var tableView: UITableView!
    var reviews: [ReviewInfo] = [ReviewInfo]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTableView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: String(describing: ReviewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ReviewCell.self))
        
        self.tableView.reloadData()
    }
    
    func reset(reviews: [ReviewInfo], loadMore: Bool = false) {
        self.reviews = reviews

        self.tableView.reloadData()
    }
}

extension ReviewsCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewCell.self)) as? ReviewCell else {
            fatalError()
        }
        
        cell.updateInfo(review: reviews[indexPath.row])
        
        return cell
    }
    
    
}
