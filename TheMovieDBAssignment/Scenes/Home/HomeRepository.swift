//
//  HomeRepository.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Alamofire
import Combine

protocol HomeRepository {
    func getTrendingList() -> AnyPublisher<MovieResponse?, ErrorInfo>
    func getCategoryList() -> AnyPublisher<MovieResponse?, ErrorInfo>
    func getPopularList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo>
    func getTopRatedList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo>
    func getUpcomingList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo>
}

final class HomeRepositoryImpl: BaseRepository, HomeRepository {
    func getTrendingList() -> AnyPublisher<MovieResponse?, ErrorInfo> {
        let provider = MovieDBProvider.trending
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    func getCategoryList() -> AnyPublisher<MovieResponse?, ErrorInfo> {
        return Future<MovieResponse?, ErrorInfo> { (promise) in
            var movie1 = MovieInfo()
            movie1.originalTitle = "Discover"
            
            var movie2 = MovieInfo()
            movie2.originalTitle = "TV Shows"
            
            var movie3 = MovieInfo()
            movie3.originalTitle = "Movies"
            
            var movie4 = MovieInfo()
            movie4.originalTitle = "People"
            
            var categoryResponse = MovieResponse()
            categoryResponse.movies.append(contentsOf: [movie1, movie2, movie3, movie4])
            
            promise(.success(categoryResponse))
        }.receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getPopularList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo> {
        let provider = MovieDBProvider.popular(page)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    func getTopRatedList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo> {
        let provider = MovieDBProvider.topRated(page)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    func getUpcomingList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo> {
        let provider = MovieDBProvider.upcoming(page)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    
    
}
