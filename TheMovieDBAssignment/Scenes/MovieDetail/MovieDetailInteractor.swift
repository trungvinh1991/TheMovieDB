//
//  MovieDetailInteractor.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Foundation
import Combine

protocol MovieDetailInteractor {
    var movieDetailPublisher: Published<MovieInfo?>.Publisher { get }
    var castsPublisher: Published<CastResponse?>.Publisher { get }
    var videosPublisher: Published<VideosResponse?>.Publisher { get }
    var reviewsPublisher: Published<ReviewsResponse?>.Publisher { get }
    var recommendationsPublisher: Published<RecommendationResponse?>.Publisher { get }
    var isFinishRefreshedPublisher: Published<Bool?>.Publisher { get }
    
    func getMovieDetail()
    func getCasts()
    func getVideos()
    func getReviews(loadMore: Bool)
    func getRecomendations(loadMore: Bool)
    
    func refreshAllData()
}

final class MovieDetailInteractorImpl: MovieDetailInteractor {
    private let movieInfo: MovieInfo
    private let repository: MovieDetailRepository
    private var dispatchGroup: DispatchGroup?
    private var disposeBag = Set<AnyCancellable>()
    
    @Published private var movieDetailResponse: MovieInfo?
    @Published private var castsResponse: CastResponse?
    @Published private var videosResponse: VideosResponse?
    @Published private var reviewsResponse: ReviewsResponse?
    @Published private var recommedationResponse: RecommendationResponse?
    @Published private var isFinishRefreshed: Bool?
    
    var movieDetailPublisher: Published<MovieInfo?>.Publisher {$movieDetailResponse}
    var castsPublisher: Published<CastResponse?>.Publisher {$castsResponse}
    var videosPublisher: Published<VideosResponse?>.Publisher {$videosResponse}
    var reviewsPublisher: Published<ReviewsResponse?>.Publisher {$reviewsResponse}
    var recommendationsPublisher: Published<RecommendationResponse?>.Publisher {$recommedationResponse}
    var isFinishRefreshedPublisher: Published<Bool?>.Publisher {$isFinishRefreshed}
    
    private var isReviewsCallingLoadMore = false
    private var isRecommendationsCallingLoadMore = false
    
    init(repository: MovieDetailRepository, movieInfo: MovieInfo) {
        self.repository = repository
        self.movieInfo = movieInfo
    }
    
    func getMovieDetail() {
        guard let movieId = movieInfo.movieId else {
            return
        }
        let publisher = self.repository.getMovieDetail(movieId: movieId)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                }
            } receiveValue: {[weak self] (response) in
                guard let response = response else {return}
                self?.movieDetailResponse = response
            }
            .store(in: &disposeBag)
    }
    
    func getCasts() {
        guard let movieId = movieInfo.movieId else {
            return
        }
        let publisher = self.repository.getCredits(movieId: movieId)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                }
            } receiveValue: {[weak self] (response) in
                guard let response = response else {return}
                self?.castsResponse = response
            }
            .store(in: &disposeBag)
    }
    
    func getVideos() {
        guard let movieId = movieInfo.movieId else {
            return
        }
        let publisher = self.repository.getVideos(movieId: movieId)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                }
            } receiveValue: {[weak self] (response) in
                guard let response = response else {return}
                self?.videosResponse = response
            }
            .store(in: &disposeBag)
    }
    
    func getReviews(loadMore: Bool = false) {
        guard let movieId = movieInfo.movieId else {
            return
        }
        var page: Int = 1
        if loadMore {
            if isReviewsCallingLoadMore {
                return
            }
            isReviewsCallingLoadMore = true
            if let currentPage = self.reviewsResponse?.page {
                page = currentPage + 1
            }
            
        }
        let publisher = self.repository.getReviews(movieId: movieId, page: page)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                    self?.isReviewsCallingLoadMore = false
                }
            } receiveValue: {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                if loadMore {
                    self.reviewsResponse?.page = response.page
                    self.reviewsResponse?.reviews.append(contentsOf: response.reviews)
                } else {
                    self.reviewsResponse = response
                }
            }
            .store(in: &disposeBag)
    }
    
    func getRecomendations(loadMore: Bool = false) {
        guard let movieId = movieInfo.movieId else {
            return
        }
        var page: Int = 1
        if loadMore {
            if isRecommendationsCallingLoadMore {
                return
            }
            isRecommendationsCallingLoadMore = true
            if let currentPage = self.recommedationResponse?.page {
                page = currentPage + 1
            }
            
        }
        let publisher = self.repository.getRecommendations(movieId: movieId, page: page)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                    self?.isRecommendationsCallingLoadMore = false
                }
            } receiveValue: {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                if loadMore {
                    self.recommedationResponse?.page = response.page
                    self.recommedationResponse?.recommendations.append(contentsOf: response.recommendations)
                } else {
                    self.recommedationResponse = response
                }
            }
            .store(in: &disposeBag)
    }
    
    func refreshAllData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        self.isFinishRefreshed = false
        
        self.getMovieDetail()
        self.getCasts()
        self.getVideos()
        self.getReviews()
        self.getRecomendations()
        
        weak var weakSelf = self
        dispatchGroup.notify(queue: DispatchQueue.main) {
            weakSelf?.isFinishRefreshed = true
            weakSelf?.dispatchGroup = nil
        }
        self.dispatchGroup = dispatchGroup
    }
}
