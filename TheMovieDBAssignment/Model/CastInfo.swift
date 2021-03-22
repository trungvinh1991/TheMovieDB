//
//  CastInfo.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import Foundation

struct CastInfo: Decodable, Hashable {
    var id = UUID()
    var knownForDepartment: String?
    var originalName: String?
    var profilePath: String?
    var rating: Int?
    
    private enum CodingKeys: String, CodingKey {
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
    }
    
    static func == (lhs: CastInfo, rhs: CastInfo) -> Bool {
        lhs.id == rhs.id
    }
}
