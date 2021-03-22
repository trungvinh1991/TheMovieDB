//
//  GenreInfo.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import Foundation

struct GenreInfo: Decodable, Hashable {
    var id = UUID()
    var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    
    static func == (lhs: GenreInfo, rhs: GenreInfo) -> Bool {
        lhs.id == rhs.id
    }
}
