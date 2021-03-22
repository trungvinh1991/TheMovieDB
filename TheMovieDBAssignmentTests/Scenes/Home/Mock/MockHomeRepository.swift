//
//  MockHomeRepository.swift
//  TheMovieDBAssignmentTests
//
//  Created by Vinh Ly on 20/03/2021.
//

import Foundation
import Combine
@testable import TheMovieDBAssignment

class MockHomeRepository: BaseRepository, HomeRepository {
    var homeMovieListType: HomeMovieList = .trending {
        didSet {
            var response = MovieResponse()
            var movies: [MovieInfo] = [MovieInfo]()
            switch homeMovieListType {
            case .trending:
                let movie1 = MovieInfo(posterPath: "trending1.png", originalTitle: "trending Title 1")
                let movie2 = MovieInfo(posterPath: "trending2.png", originalTitle: "trending Title 2")
                let movie3 = MovieInfo(posterPath: "trending3.png", originalTitle: "trending Title 3")
                let movie4 = MovieInfo(posterPath: "trending4.png", originalTitle: "trending Title 4")
                let movie5 = MovieInfo(posterPath: "trending5.png", originalTitle: "trending Title 5")
                
                movies.append(contentsOf: [movie1, movie2, movie3, movie4, movie5])
            case .category:
                let movie1 = MovieInfo(originalTitle: "category Title 1")
                let movie2 = MovieInfo(originalTitle: "category Title 2")
                let movie3 = MovieInfo(originalTitle: "category Title 3")
                let movie4 = MovieInfo(originalTitle: "category Title 4")
                let movie5 = MovieInfo(originalTitle: "category Title 5")
                
                movies.append(contentsOf: [movie1, movie2, movie3, movie4, movie5])
            case .popular:
                let movie1 = MovieInfo(posterPath: "popular1.png", originalTitle: "popular Title 1")
                let movie2 = MovieInfo(posterPath: "popular2.png", originalTitle: "popular Title 2")
                let movie3 = MovieInfo(posterPath: "popular3.png", originalTitle: "popular Title 3")
                let movie4 = MovieInfo(posterPath: "popular4.png", originalTitle: "popular Title 4")
                let movie5 = MovieInfo(posterPath: "popular5.png", originalTitle: "popular Title 5")
                
                movies.append(contentsOf: [movie1, movie2, movie3, movie4, movie5])
            case .topRated:
                let movie1 = MovieInfo(posterPath: "toprated1.png", originalTitle: "toprated Title 1")
                let movie2 = MovieInfo(posterPath: "toprated2.png", originalTitle: "toprated Title 2")
                let movie3 = MovieInfo(posterPath: "toprated3.png", originalTitle: "toprated Title 3")
                let movie4 = MovieInfo(posterPath: "toprated4.png", originalTitle: "toprated Title 4")
                let movie5 = MovieInfo(posterPath: "toprated5.png", originalTitle: "toprated Title 5")
                
                movies.append(contentsOf: [movie1, movie2, movie3, movie4, movie5])
            case .upcoming:
                let movie1 = MovieInfo(posterPath: "upcoming1.png", originalTitle: "upcoming Title 1")
                let movie2 = MovieInfo(posterPath: "upcoming2.png", originalTitle: "upcoming Title 2")
                let movie3 = MovieInfo(posterPath: "upcoming3.png", originalTitle: "upcoming Title 3")
                let movie4 = MovieInfo(posterPath: "upcoming4.png", originalTitle: "upcoming Title 4")
                let movie5 = MovieInfo(posterPath: "upcoming5.png", originalTitle: "upcoming Title 5")
                
                movies.append(contentsOf: [movie1, movie2, movie3, movie4, movie5])
            }
            response.movies = movies
            self.responseMovie = response
            self.isHaveError = false
        }
    }
    
    var isHaveError: Bool = false
    
    var responseMovie: MovieResponse?
    
    func getTrendingList() -> AnyPublisher<MovieResponse?, ErrorInfo> {
        return Future<MovieResponse?, ErrorInfo>({[weak self] (promise) in
            guard let self = self else {return}
            if self.isHaveError == true {
                promise(.failure(ErrorInfo()))
                return
            }
            promise(.success(self.responseMovie))
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getCategoryList() -> AnyPublisher<MovieResponse?, ErrorInfo> {
        return Future<MovieResponse?, ErrorInfo>({[weak self] (promise) in
            guard let self = self else {return}
            if self.isHaveError == true {
                promise(.failure(ErrorInfo()))
                return
            }
            promise(.success(self.responseMovie))
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getPopularList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo> {
        return Future<MovieResponse?, ErrorInfo>({[weak self] (promise) in
            guard let self = self else {return}
            if self.isHaveError == true {
                promise(.failure(ErrorInfo()))
                return
            }
            promise(.success(self.responseMovie))
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getTopRatedList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo> {
        return Future<MovieResponse?, ErrorInfo>({[weak self] (promise) in
            guard let self = self else {return}
            if self.isHaveError == true {
                promise(.failure(ErrorInfo()))
                return
            }
            promise(.success(self.responseMovie))
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getUpcomingList(page: Int) -> AnyPublisher<MovieResponse?, ErrorInfo> {
        return Future<MovieResponse?, ErrorInfo>({[weak self] (promise) in
            guard let self = self else {return}
            if self.isHaveError == true {
                promise(.failure(ErrorInfo()))
                return
            }
            promise(.success(self.responseMovie))
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
}
