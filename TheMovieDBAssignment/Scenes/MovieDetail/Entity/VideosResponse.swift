//
//  VideosResponse.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 22/03/2021.
//

import Foundation

struct VideosResponse: Decodable {
    var videos: [VideoInfo]
    
    init() {
        videos = []
    }
    
    private enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
}
