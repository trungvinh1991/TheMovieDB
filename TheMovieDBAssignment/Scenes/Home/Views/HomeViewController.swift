//
//  HomeViewController.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import UIKit
import Combine
import SDWebImage

enum HomeMovieList {
    case trending
    case category
    case popular
    case topRated
    case upcoming
}

class HomeViewController: UIViewController {
    static let sectionHeaderElementKind = "section-header-element-kind"
    let trendingSize = CGSize(width: 300, height: 180)
    let commonSize = CGSize(width: (300 - 20) / 2, height: 280)
    let categorySize = CGSize(width: (300 - 20) / 2, height: 90)
    let padding: CGFloat = 16
    let topPadding: CGFloat = 16
    let interItemSpacing: CGFloat = 20
    let headerHeight: CGFloat = 46
    let maxPage: Int = 3
    let minItemsForInfiniteScroll: Int = 3
    
    let presenter: HomePresenter
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var userButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var trendingResponse: MovieResponse = MovieResponse()
    @Published var categoryResponse: MovieResponse = MovieResponse()
    @Published var popularResponse: MovieResponse = MovieResponse()
    @Published var topRatedResponse: MovieResponse = MovieResponse()
    @Published var upcomingResponse: MovieResponse = MovieResponse()
    
    enum Section: String, CaseIterable {
        case trending = "TRENDING"
        case category = "CATEGORY"
        case popular = "POPULAR"
        case topRated = "TOP RATED"
        case upcoming = "UPCOMING"
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MovieInfo>!
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: String(describing: HomeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configShadowHeaderView()
        self.configCollectionView()
        self.configDataSource()
        self.initiateRefreshData()
        self.presenter.trendingPublisher
            .sink {[weak self] (response) in
                guard let self = self else {return}
                self.trendingResponse = response
                
                if response.movies.count > 0 {
                var snapshot = self.dataSource.snapshot()
                    snapshot.appendItems(response.movies, toSection: Section.trending)
                    self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
                }
                
            }.store(in: &cancellables)
        self.presenter.categoryPublisher
            .sink {[weak self] (response) in
                guard let self = self else {return}
                self.categoryResponse = response
                
                if response.movies.count > 0 {
                    var snapshot = self.dataSource.snapshot()
                    snapshot.appendItems(response.movies, toSection: Section.category)
                    self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
                }
                
            }.store(in: &cancellables)
        self.presenter.popularPublisher
            .sink {[weak self] (response) in
                guard let self = self else {return}
                var refreshMovie = MovieInfo()
                refreshMovie.isRefreshControl = true
                var snapshot = self.dataSource.snapshot()
                
                let filterList = self.popularResponse.movies.filter { (movie) -> Bool in
                    return movie.isRefreshControl
                }
                if filterList.count > 0 {
                    refreshMovie = filterList[0]
                    if let index = self.popularResponse.movies.firstIndex(of: refreshMovie) {
                        self.popularResponse.movies.remove(at: index)
                    }
                }
                
                //Append new data
                if response.page == 1 {
                    self.popularResponse = response
                } else {
                    self.popularResponse.page = response.page
                    self.popularResponse.movies.append(contentsOf: response.movies)
                }
                snapshot.appendItems(response.movies, toSection: Section.popular)
                
                //Delete refresh control
                snapshot.deleteItems([refreshMovie])
                if self.popularResponse.page < self.maxPage && self.popularResponse.movies.count > self.minItemsForInfiniteScroll {
                    self.popularResponse.movies.append(refreshMovie)
                    snapshot.appendItems([refreshMovie], toSection: Section.popular)
                }
                
                self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
                
            }.store(in: &cancellables)
        self.presenter.topRatedPublisher
            .sink {[weak self] (response) in
                guard let self = self else {return}
                var refreshMovie = MovieInfo()
                refreshMovie.isRefreshControl = true
                var snapshot = self.dataSource.snapshot()
                
                let filterList = self.topRatedResponse.movies.filter { (movie) -> Bool in
                    return movie.isRefreshControl
                }
                if filterList.count > 0 {
                    refreshMovie = filterList[0]
                    if let index = self.topRatedResponse.movies.firstIndex(of: refreshMovie) {
                        self.topRatedResponse.movies.remove(at: index)
                    }
                }
                
                //Append new data
                if response.page == 1 {
                    self.topRatedResponse = response
                } else {
                    self.topRatedResponse.page = response.page
                    self.topRatedResponse.movies.append(contentsOf: response.movies)
                }
                snapshot.appendItems(response.movies, toSection: Section.topRated)
                
                //Delete refresh control
                snapshot.deleteItems([refreshMovie])
                if self.topRatedResponse.page < self.maxPage && self.topRatedResponse.movies.count > self.minItemsForInfiniteScroll {
                    self.topRatedResponse.movies.append(refreshMovie)
                    snapshot.appendItems([refreshMovie], toSection: Section.topRated)
                }
                
                self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
                
            }.store(in: &cancellables)
        self.presenter.upcomingPublisher
            .sink {[weak self] (response) in
                guard let self = self else {return}
                var refreshMovie = MovieInfo()
                refreshMovie.isRefreshControl = true
                var snapshot = self.dataSource.snapshot()
                
                let filterList = self.upcomingResponse.movies.filter { (movie) -> Bool in
                    return movie.isRefreshControl
                }
                if filterList.count > 0 {
                    refreshMovie = filterList[0]
                    if let index = self.upcomingResponse.movies.firstIndex(of: refreshMovie) {
                        self.upcomingResponse.movies.remove(at: index)
                    }
                }
                
                //Append new data
                if response.page == 1 {
                    self.upcomingResponse = response
                } else {
                    self.upcomingResponse.page = response.page
                    self.upcomingResponse.movies.append(contentsOf: response.movies)
                }
                snapshot.appendItems(response.movies, toSection: Section.upcoming)
                
                //Delete refresh control
                snapshot.deleteItems([refreshMovie])
                if self.upcomingResponse.page < self.maxPage && self.upcomingResponse.movies.count > self.minItemsForInfiniteScroll {
                    self.upcomingResponse.movies.append(refreshMovie)
                    snapshot.appendItems([refreshMovie], toSection: Section.upcoming)
                }
                
                self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
                
            }.store(in: &cancellables)
        self.presenter.isFinishRefreshedPublisher
            .sink {[weak self] (finished) in
                if finished == true {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        self.presenter.refreshAllData()
        // Do any additional setup after loading the view.
    }
    
    private func configShadowHeaderView() {
        headerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.23).cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 10
        headerView.layer.shouldRasterize = true
        headerView.layer.rasterizationScale = UIScreen.main.scale
    }


    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = self.generateLayout()
        collectionView.register(UINib(nibName: String(describing: HomeTrendingCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HomeTrendingCell.self))
        collectionView.register(UINib(nibName: String(describing: CommonMovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CommonMovieCell.self))
        collectionView.register(UINib(nibName: String(describing: CategoryCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CategoryCell.self))
        
        collectionView.register(UINib(nibName: String(describing: HomeHeaderView.self), bundle: nil), forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind, withReuseIdentifier: String(describing: HomeHeaderView.self))
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }

    private func configDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Section, MovieInfo>(collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            case .popular, .topRated, .upcoming:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CommonMovieCell.self), for: indexPath) as? CommonMovieCell else {
                    fatalError()
                }
                cell.updateInfo(movie: movie)
                if movie.isRefreshControl {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        switch sectionType {
                        case .popular:
                            self.presenter.loadingPopularResponse(loadMore: true)
                        case .topRated:
                            self.presenter.loadingTopRatedResponse(loadMore: true)
                        case .upcoming:
                            self.presenter.loadingUpcomingResponse(loadMore: true)
                        default:
                            break
                        }
                        
                    }
                }
                return cell
            case .trending:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeTrendingCell.self), for: indexPath) as? HomeTrendingCell else {
                    fatalError()
                }
                cell.updateInfo(movie: movie)
                return cell
            case .category:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self), for: indexPath) as? CategoryCell else {
                    fatalError()
                }
                cell.updateInfo(movie: movie)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: HomeHeaderView.self),
                    for: indexPath) as? HomeHeaderView else { fatalError("Cannot create header view") }

            supplementaryView.titleLabel.text = Section.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        
        let snapshot = snapshots()
        dataSource.apply(snapshot, animatingDifferences: false)
        
        self.dataSource = dataSource
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            guard let self = self else {fatalError()}

            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .trending:
                return self.generateTrendingLayout()
            case .popular, .topRated, .upcoming:
                return self.generateCommonLayout()
            case .category:
                return self.generateCategoryLayout()
            }
        }
      return layout
    }
    
    private func generateTrendingLayout() -> NSCollectionLayoutSection {
        
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Show one item plus peek on narrow screens, two items plus peek on wider screens
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(trendingSize.width),
            heightDimension: .absolute(trendingSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        //Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top
        )
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: -topPadding, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
        section.interGroupSpacing = interItemSpacing
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    private func generateCommonLayout() -> NSCollectionLayoutSection {
        let itemWidthScale: CGFloat = 1
        let itemHeightScale: CGFloat = 1
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthScale),
                                              heightDimension: .fractionalHeight(itemHeightScale))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Show one item plus peek on narrow screens, two items plus peek on wider screens
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(commonSize.width),
            heightDimension: .absolute(commonSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        //Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top
        )
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: -topPadding, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
        section.interGroupSpacing = interItemSpacing
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = ({ (visibleItems, point, env) in
            
        })

        return section
    }
    
    private func generateCategoryLayout() -> NSCollectionLayoutSection {
        
        let itemWidthScale: CGFloat = 1
        let itemHeightScale: CGFloat = 1
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthScale),
                                              heightDimension: .fractionalHeight(itemHeightScale))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Show one item plus peek on narrow screens, two items plus peek on wider screens
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(categorySize.width),
            heightDimension: .absolute(categorySize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(interItemSpacing)
        
        //Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(46))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top
        )
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: -topPadding, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
        section.interGroupSpacing = interItemSpacing
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    private func snapshots() -> NSDiffableDataSourceSnapshot<Section, MovieInfo> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieInfo>()
        snapshot.appendSections(Section.allCases)
        
        return snapshot
    }
    
    func initiateRefreshData() {

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }

    @objc private func refreshOptions(sender: UIRefreshControl) {
        self.resetAll()
        self.presenter.refreshAllData()
    }
    
    private func resetAll() {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems(self.trendingResponse.movies)
        snapshot.deleteItems(self.categoryResponse.movies)
        snapshot.deleteItems(self.popularResponse.movies)
        snapshot.deleteItems(self.topRatedResponse.movies)
        snapshot.deleteItems(self.upcomingResponse.movies)
        self.trendingResponse.movies.removeAll()
        self.categoryResponse.movies.removeAll()
        self.popularResponse.movies.removeAll()
        self.topRatedResponse.movies.removeAll()
        self.upcomingResponse.movies.removeAll()
        self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let sectionKind = Section.allCases[indexPath.section]
        switch sectionKind {
        case .trending, .popular, .topRated, .upcoming:
            self.presenter.moveToMovieDetailScreen(view: self, movie: movie)
        default:
            break
        }
    }
}
