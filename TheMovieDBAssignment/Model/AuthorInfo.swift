//
//  AuthorInfo.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import Foundation

struct AuthorInfo: Decodable, Hashable {
    var id = UUID()
    var name: String?
    var username: String?
    var avatarPath: String?
    var rating: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case username = "username"
        case avatarPath = "avatar_path"
        case rating = "rating"
    }
    
    static func == (lhs: AuthorInfo, rhs: AuthorInfo) -> Bool {
        lhs.id == rhs.id
    }
}
