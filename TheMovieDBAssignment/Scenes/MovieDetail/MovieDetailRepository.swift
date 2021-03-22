//
//  MovieDetailRepository.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Foundation
import Combine

protocol MovieDetailRepository {
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieInfo?, ErrorInfo>
    func getCredits(movieId: Int) -> AnyPublisher<CastResponse?, ErrorInfo>
    func getVideos(movieId: Int) -> AnyPublisher<VideosResponse?, ErrorInfo>
    func getReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewsResponse?, ErrorInfo>
    func getRecommendations(movieId: Int, page: Int) -> AnyPublisher<RecommendationResponse?, ErrorInfo>
}

final class MovieDetailRepositoryImpl: BaseRepository, MovieDetailRepository {
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieInfo?, ErrorInfo> {
        let provider = MovieDBProvider.movieDetail(movieId)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    func getCredits(movieId: Int) -> AnyPublisher<CastResponse?, ErrorInfo> {
        let provider = MovieDBProvider.cast(movieId)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    func getVideos(movieId: Int) -> AnyPublisher<VideosResponse?, ErrorInfo> {
        let provider = MovieDBProvider.videos(movieId)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    func getReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewsResponse?, ErrorInfo> {
        let provider = MovieDBProvider.reviews(movieId, page)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
    func getRecommendations(movieId: Int, page: Int) -> AnyPublisher<RecommendationResponse?, ErrorInfo> {
        let provider = MovieDBProvider.recomendations(movieId, page)
        return self.request(url: provider.url,
                            method: provider.method,
                            params: provider.params,
                            headers: provider.headers)
    }
    
}
