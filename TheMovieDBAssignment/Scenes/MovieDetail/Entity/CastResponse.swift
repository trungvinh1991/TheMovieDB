//
//  CastResponse.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import Foundation

struct CastResponse: Decodable {
    var casts: [CastInfo]
    
    init() {
        casts = []
    }
    
    private enum CodingKeys: String, CodingKey {
        case casts = "cast"
    }
}
