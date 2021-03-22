//
//  MovieDetailPresenter.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Foundation
import UIKit
import Combine

protocol MovieDetailPresenter {
    var movieDetailPublisher: Published<MovieInfo?>.Publisher { get }
    var castsPublisher: Published<CastResponse?>.Publisher { get }
    var videosPublisher: Published<VideosResponse?>.Publisher { get }
    var reviewsPublisher: Published<ReviewsResponse?>.Publisher { get }
    var recommendationsPublisher: Published<RecommendationResponse?>.Publisher { get }
    var isFinishRefreshedPublisher: Published<Bool?>.Publisher { get }
    
    func loadingMovieDetail()
    func loadingCasts()
    func loadingVideos()
    func loadingReviews(loadMore: Bool)
    func loadingRecomendations(loadMore: Bool)
    func refreshAllData()
    func backToPreviousScreen(currentView: UIViewController)
}

final class MovieDetailPresenterImpl: MovieDetailPresenter {
    private let interactor: MovieDetailInteractor
    private let router = MovieDetailRouterImpl()
    private let movie: MovieInfo
    private var cancellables = Set<AnyCancellable>()
    
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
    
    init(interactor: MovieDetailInteractor, movie: MovieInfo) {
        self.interactor = interactor
        self.movie = movie
        
        self.interactor.movieDetailPublisher
            .assign(to: \.movieDetailResponse, on: self)
            .store(in: &cancellables)
        self.interactor.castsPublisher
            .assign(to: \.castsResponse, on: self)
            .store(in: &cancellables)
        self.interactor.videosPublisher
            .assign(to: \.videosResponse, on: self)
            .store(in: &cancellables)
        self.interactor.reviewsPublisher
            .assign(to: \.reviewsResponse, on: self)
            .store(in: &cancellables)
        self.interactor.recommendationsPublisher
            .assign(to: \.recommedationResponse, on: self)
            .store(in: &cancellables)
        self.interactor.isFinishRefreshedPublisher
            .assign(to: \.isFinishRefreshed, on: self)
            .store(in: &cancellables)
    }
    
    func loadingMovieDetail() {
        self.interactor.getMovieDetail()
    }
    
    func loadingCasts() {
        self.interactor.getCasts()
    }
    
    func loadingVideos() {
        self.interactor.getVideos()
    }
    
    func loadingReviews(loadMore: Bool = false) {
        self.interactor.getReviews(loadMore: loadMore)
    }
    
    func loadingRecomendations(loadMore: Bool = false) {
        self.interactor.getRecomendations(loadMore: loadMore)
    }

    func refreshAllData() {
        self.interactor.refreshAllData()
    }
    
    func backToPreviousScreen(currentView: UIViewController) {
        self.router.backToPreviousScreen(currentView: currentView)
    }
}
