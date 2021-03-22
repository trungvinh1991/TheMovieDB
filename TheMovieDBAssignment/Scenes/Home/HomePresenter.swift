//
//  HomePresenter.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import UIKit
import Combine

protocol HomePresenter {
    var trendingPublisher: Published<MovieResponse>.Publisher { get }
    var categoryPublisher: Published<MovieResponse>.Publisher { get }
    var popularPublisher: Published<MovieResponse>.Publisher { get }
    var topRatedPublisher: Published<MovieResponse>.Publisher { get }
    var upcomingPublisher: Published<MovieResponse>.Publisher { get }
    var isFinishRefreshedPublisher: Published<Bool?>.Publisher { get }
    
    func loadingTrendingResponse()
    func loadingCategoryResponse()
    func loadingPopularResponse(loadMore: Bool)
    func loadingTopRatedResponse(loadMore: Bool)
    func loadingUpcomingResponse(loadMore: Bool)
    func refreshAllData()
    func moveToMovieDetailScreen(view: UIViewController, movie: MovieInfo)
}

final class HomePresenterImpl: ObservableObject, HomePresenter {
    private let interactor: HomeInteractor
    private let router = HomeRouterImpl()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var trendingResponse: MovieResponse = MovieResponse()
    @Published var categoryResponse: MovieResponse = MovieResponse()
    @Published var popularResponse: MovieResponse = MovieResponse()
    @Published var topRatedResponse: MovieResponse = MovieResponse()
    @Published var upcomingResponse: MovieResponse = MovieResponse()
    @Published private var isFinishRefreshed: Bool?
    
    var trendingPublisher: Published<MovieResponse>.Publisher { $trendingResponse }
    var categoryPublisher: Published<MovieResponse>.Publisher { $categoryResponse }
    var popularPublisher: Published<MovieResponse>.Publisher { $popularResponse }
    var topRatedPublisher: Published<MovieResponse>.Publisher { $topRatedResponse }
    var upcomingPublisher: Published<MovieResponse>.Publisher { $upcomingResponse }
    var isFinishRefreshedPublisher: Published<Bool?>.Publisher { $isFinishRefreshed }
    
    init(interactor: HomeInteractor) {
        self.interactor = interactor
        
        self.interactor.trendingPublisher
            .assign(to: \.trendingResponse, on: self)
            .store(in: &cancellables)
        
        self.interactor.categoryPublisher
            .assign(to: \.categoryResponse, on: self)
            .store(in: &cancellables)
        
        self.interactor.popularPublisher
            .assign(to: \.popularResponse, on: self)
            .store(in: &cancellables)
        
        self.interactor.topRatedPublisher
            .assign(to: \.topRatedResponse, on: self)
            .store(in: &cancellables)
        
        self.interactor.upcomingPublisher
            .assign(to: \.upcomingResponse, on: self)
            .store(in: &cancellables)
        
        self.interactor.isFinishRefreshedPublisher
            .assign(to: \.isFinishRefreshed, on: self)
            .store(in: &cancellables)
    }
    
    func loadingTrendingResponse() {
        self.interactor.getTrendingList()
    }
    
    func loadingCategoryResponse() {
        self.interactor.getCategoryList()
    }
    
    func loadingPopularResponse(loadMore: Bool) {
        self.interactor.getPopularList(loadMore: loadMore)
    }
    
    func loadingTopRatedResponse(loadMore: Bool) {
        self.interactor.getTopRatedList(loadMore: loadMore)
    }
    
    func loadingUpcomingResponse(loadMore: Bool) {
        self.interactor.getUpcomingList(loadMore: loadMore)
    }
    
    func refreshAllData() {
        self.interactor.refreshAllData()
    }
    
    func moveToMovieDetailScreen(view: UIViewController, movie: MovieInfo) {
        self.router.moveToMovieDetail(currentView: view, movie: movie)
    }
}
