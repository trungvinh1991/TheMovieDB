//
//  RecommendationResponse.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import Foundation

struct RecommendationResponse: Decodable {
    var page: Int = 1
    var recommendations: [MovieInfo]
    
    init() {
        recommendations = []
    }
    
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case recommendations = "results"
    }
}
