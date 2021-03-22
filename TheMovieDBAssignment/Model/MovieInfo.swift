//
//  MovieInfo.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Foundation

struct MovieInfo: Decodable, Hashable {
    var isRefreshControl = false
    var id = UUID()
    var movieId: Int?
    var posterPath: String?
    var backdropPath: String?
    var originalTitle: String?
    var overview: String?
    var releaseDate: Date?
    var genres: [GenreInfo]?
    
    var voteAverage: Double?
    
    private enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case overview = "overview"
        case releaseDate = "release_date"
        case genres = "genres"
        case voteAverage = "vote_average"
    }
    
    static func == (lhs: MovieInfo, rhs: MovieInfo) -> Bool {
        lhs.id == rhs.id
    }
}
