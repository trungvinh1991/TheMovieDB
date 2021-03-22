//
//  ReviewsResponse.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import Foundation

struct ReviewsResponse: Decodable {
    var page: Int = 1
    var reviews: [ReviewInfo]
    
    init() {
        reviews = []
    }
    
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case reviews = "results"
    }
}
