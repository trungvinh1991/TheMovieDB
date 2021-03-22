//
//  MovieDetailViewController.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

enum APILoadingState {
    case none
    case loadMore
    case refresh
}

class MovieDetailViewController: BaseViewController {
    let presenter: MovieDetailPresenter
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var movieDetailResponse: MovieInfo?
    @Published var castResponse: CastResponse?
    @Published var videosResponse: VideosResponse?
    @Published var reviewsResponse: ReviewsResponse?
    @Published var topRatedResponse: VideosResponse?
    @Published var recResponse: RecommendationResponse?
    
    private var castAPIState: APILoadingState = .none
    private var videosAPIState: APILoadingState = .none
    private var reviewAPIState: APILoadingState = .none
    private var recAPIState: APILoadingState = .none
    
    enum MovieDetailSection: Int, CaseIterable {
        case detail = 0
        case rate
        case seriesCast
        case video
        case comment
        case recommend
        
        func title() -> String {
            switch self {
            case .detail:
                return ""
            case .rate:
                return "Your Rate"
            case .seriesCast:
                return "Series Cast"
            case .video:
                return "Video"
            case .comment:
                return "Comments"
            case .recommend:
                return "Recommendations"
            }
        }
    }
    
    init(presenter: MovieDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: String(describing: MovieDetailViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self
        self.backButton.rx.tap
            .bind {
                guard let self = weakSelf else {return}
                self.presenter.backToPreviousScreen(currentView: self)
            }
            .disposed(by: disposeBag)
        
        self.configTableView()
        self.setupPublishers()
        self.presenter.refreshAllData()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib(nibName: String(describing: MovieDetailHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: MovieDetailHeaderView.self))
        
        tableView.register(UINib(nibName: String(describing: MovieDetailCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieDetailCell.self))
        tableView.register(UINib(nibName: String(describing: RateCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RateCell.self))
        tableView.register(UINib(nibName: String(describing: ReviewsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ReviewsCell.self))
        tableView.register(UINib(nibName: String(describing: CastsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CastsCell.self))
        tableView.register(UINib(nibName: String(describing: VideosCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VideosCell.self))
        tableView.register(UINib(nibName: String(describing: RecommendationsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RecommendationsCell.self))
    }
    
    func setupPublishers() {
        self.presenter.movieDetailPublisher
            .sink {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
//                self.castAPIState = .refresh
                self.movieDetailResponse = response
                self.tableView.reloadSections(IndexSet(integer: MovieDetailSection.detail.rawValue), with: .automatic)
            }.store(in: &cancellables)
        self.presenter.castsPublisher
            .sink {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                self.castAPIState = .refresh
                self.castResponse = response
                self.tableView.reloadSections(IndexSet(integer: MovieDetailSection.seriesCast.rawValue), with: .automatic)
            }.store(in: &cancellables)
        self.presenter.videosPublisher
            .sink {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                self.videosAPIState = .refresh
                self.videosResponse = response
                self.tableView.reloadSections(IndexSet(integer: MovieDetailSection.video.rawValue), with: .automatic)
            }.store(in: &cancellables)
        self.presenter.reviewsPublisher
            .sink {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                
                if response.page == 1 {
                    self.reviewAPIState = .refresh
                    self.reviewsResponse = response
                } else {
                    self.reviewAPIState = .loadMore
                    self.reviewsResponse?.page = response.page
                    self.reviewsResponse?.reviews.append(contentsOf: response.reviews)
                }
                self.tableView.reloadSections(IndexSet(integer: MovieDetailSection.comment.rawValue), with: response.page == 1 ? .automatic : .none)
            }.store(in: &cancellables)
        
        self.presenter.recommendationsPublisher
            .sink {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                self.recAPIState = .refresh
                self.recResponse = response
                self.tableView.reloadSections(IndexSet(integer: MovieDetailSection.recommend.rawValue), with: .automatic)
            }.store(in: &cancellables)
        self.presenter.isFinishRefreshedPublisher
            .sink {[weak self] (finished) in
                guard let self = self else {return}
                if finished == true {
                    self.stopRefreshAnimating(scrollView: self.tableView)
                }
            }
            .store(in: &cancellables)
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = MovieDetailSection(rawValue: section) ?? .detail
        if sectionType == .detail {
            return 0
        }
        return 48.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MovieDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = MovieDetailSection(rawValue: section),
              sectionType != .detail,
              let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MovieDetailHeaderView.self)) as? MovieDetailHeaderView else {
            return nil
        }
        headerView.arrowButton.isHidden = sectionType != .comment && sectionType != .recommend
        headerView.titleLabel.text = sectionType.title()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = MovieDetailSection(rawValue: indexPath.section) ?? .detail
        
        switch sectionType {
        case .detail:
            return UITableView.automaticDimension
        case .rate:
            return UITableView.automaticDimension
        case .seriesCast:
            return CastsCell.commonSize.height + 10
        case .video:
            return VideosCell.commonSize.height + 30
        case .comment:
            return ReviewsCell.height
        case .recommend:
            return RecommendationsCell.commonSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = MovieDetailSection(rawValue: indexPath.section) ?? .detail
        switch sectionType {
        case .detail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailCell.self)) as? MovieDetailCell else {
                fatalError()
            }
            
            if let movie = movieDetailResponse {
                cell.updateInfo(movie: movie)
            }
            return cell
        case .rate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RateCell.self)) as? RateCell else {
                fatalError()
            }
            
            
            return cell
        case .seriesCast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CastsCell.self)) as? CastsCell else {
                fatalError()
            }
            if self.castAPIState != .none, castResponse?.casts != nil {
                cell.reset(casts: castResponse!.casts)
                self.castAPIState = .none
            }
            
            return cell
        case .video:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideosCell.self)) as? VideosCell else {
                fatalError()
            }
            
            if self.videosAPIState != .none, videosResponse?.videos != nil {
                cell.reset(videos: videosResponse!.videos)
                self.videosAPIState = .none
            }
            
            return cell
        case .comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewsCell.self)) as? ReviewsCell else {
                fatalError()
            }
            if self.reviewAPIState != .none, reviewsResponse?.reviews != nil {
                cell.reset(reviews: reviewsResponse!.reviews, loadMore: self.reviewAPIState == .loadMore)
                self.reviewAPIState = .none
            }
            
            weak var weakSelf = self
            self.setInifiniteScroll(scrollView: cell.tableView, isInfiniteScroll: true) {
                guard let self = weakSelf else {return}
                self.presenter.loadingReviews(loadMore: true)
            }
            
            return cell
        case .recommend:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecommendationsCell.self)) as? RecommendationsCell else {
                fatalError()
            }
            if self.recAPIState != .none, recResponse?.recommendations != nil {
                cell.reset(movies: recResponse!.recommendations)
                self.recAPIState = .none
            }
            
//            weak var weakSelf = self
//            self.setInifiniteScroll(scrollView: cell.collectionView, isInfiniteScroll: true) {
//                guard let self = weakSelf else {
//                    return
//                }
//                self.presenter.loadingRecomendations(loadMore: true)
//            }
            
            return cell
        }
    }
    
    
}
