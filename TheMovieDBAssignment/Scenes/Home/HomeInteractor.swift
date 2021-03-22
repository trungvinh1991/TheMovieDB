//
//  HomeInteractor.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Combine
import Foundation

protocol HomeInteractor {
    var trendingPublisher: Published<MovieResponse>.Publisher { get }
    var categoryPublisher: Published<MovieResponse>.Publisher { get }
    var popularPublisher: Published<MovieResponse>.Publisher { get }
    var topRatedPublisher: Published<MovieResponse>.Publisher { get }
    var upcomingPublisher: Published<MovieResponse>.Publisher { get }
    var isFinishRefreshedPublisher: Published<Bool?>.Publisher { get }
    
    func getTrendingList()
    func getCategoryList()
    func getPopularList(loadMore: Bool)
    func getTopRatedList(loadMore: Bool)
    func getUpcomingList(loadMore: Bool)
    
    func refreshAllData()
}

final class HomeInteractorImpl: HomeInteractor {
    private let repository: HomeRepository
    private var disposeBag = Set<AnyCancellable>()
    @Published private var trendingResponse: MovieResponse = MovieResponse()
    @Published private var categoryResponse: MovieResponse = MovieResponse()
    @Published private var popularResponse: MovieResponse = MovieResponse()
    @Published private var topRatedResponse: MovieResponse = MovieResponse()
    @Published private var upcomingResponse: MovieResponse = MovieResponse()
    @Published private var isFinishRefreshed: Bool?
    
    var trendingPublisher: Published<MovieResponse>.Publisher { $trendingResponse }
    var categoryPublisher: Published<MovieResponse>.Publisher { $categoryResponse }
    var popularPublisher: Published<MovieResponse>.Publisher { $popularResponse }
    var topRatedPublisher: Published<MovieResponse>.Publisher { $topRatedResponse }
    var upcomingPublisher: Published<MovieResponse>.Publisher { $upcomingResponse }
    var isFinishRefreshedPublisher: Published<Bool?>.Publisher {$isFinishRefreshed }
    
    private var isPopularCallingLoadMore = false
    private var isTopRatedCallingLoadMore = false
    private var isUpcomingCallingLoadMore = false
//    private var isPopularCallingLoadMore = false
    
    private var dispatchGroup: DispatchGroup?
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func getTrendingList() {
        let publisher = self.repository.getTrendingList()
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                }
            } receiveValue: {[weak self] (response) in
                guard let movieResponse = response else {return}
                self?.trendingResponse = movieResponse
            }
            .store(in: &disposeBag)

    }
    
    func getPopularList(loadMore: Bool = false) {
        if loadMore {
            if isPopularCallingLoadMore {
                return
            }
            isPopularCallingLoadMore = true
        }
        let publisher = self.repository.getPopularList(page: loadMore ? self.popularResponse.page + 1 : 1)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                    self?.isPopularCallingLoadMore = false
                }
            } receiveValue: {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                if loadMore {
                    self.popularResponse.page = response.page
                    self.popularResponse.movies.append(contentsOf: response.movies)
                } else {
                    self.popularResponse = response
                }
            }
            .store(in: &disposeBag)
    }
    
    func getCategoryList() {
        let publisher = self.repository.getCategoryList()
        publisher
            .sink { _ in
                
            } receiveValue: {[weak self] (response) in
                guard let response = response else {return}
                self?.categoryResponse = response
            }
            .store(in: &disposeBag)
    }
    
    func getTopRatedList(loadMore: Bool = false) {
        if loadMore {
            if isTopRatedCallingLoadMore {
                return
            }
            isTopRatedCallingLoadMore = true
        }
        let publisher = self.repository.getTopRatedList(page: loadMore ? self.topRatedResponse.page + 1 : 1)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                    self?.isTopRatedCallingLoadMore = false
                }
            } receiveValue: {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                if loadMore {
                    self.topRatedResponse.page = response.page
                    self.topRatedResponse.movies.append(contentsOf: response.movies)
                } else {
                    self.topRatedResponse = response
                }
            }
            .store(in: &disposeBag)
    }
    
    func getUpcomingList(loadMore: Bool = false) {
        if loadMore {
            if isUpcomingCallingLoadMore {
                return
            }
            isUpcomingCallingLoadMore = true
        }
        let publisher = self.repository.getUpcomingList(page: loadMore ? self.upcomingResponse.page + 1 : 1)
        publisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    self?.dispatchGroup?.leave()
                    self?.isUpcomingCallingLoadMore = false
                }
            } receiveValue: {[weak self] (response) in
                guard let self = self,
                      let response = response else {return}
                if loadMore {
                    self.upcomingResponse.page = response.page
                    self.upcomingResponse.movies.append(contentsOf: response.movies)
                } else {
                    self.upcomingResponse = response
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
        
        self.getTrendingList()
        self.getCategoryList()
        self.getPopularList()
        self.getUpcomingList()
        self.getTopRatedList()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.isFinishRefreshed = true
            self.dispatchGroup = nil
        }
        self.dispatchGroup = dispatchGroup
    }
}
