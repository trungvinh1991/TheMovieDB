//
//  VideoInfo.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 22/03/2021.
//

import Foundation

struct VideoInfo: Decodable, Hashable {
    var id = UUID()
    var posterPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
    }
    
    static func == (lhs: VideoInfo, rhs: VideoInfo) -> Bool {
        lhs.id == rhs.id
    }
}
