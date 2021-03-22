//
//  MovieResponse.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Foundation

struct MovieResponse: Decodable {
    var page: Int = 1
    var movies: [MovieInfo]
    
    init() {
        movies = []
    }
    
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case movies = "results"
    }
}
