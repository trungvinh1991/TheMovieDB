//
//  ReviewInfo.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 21/03/2021.
//

import Foundation

struct ReviewInfo: Decodable, Hashable {
    var id = UUID()
    var reviewId: String?
    var author: String?
    var authorDetail: AuthorInfo?
    var content: String?
    var createdAt: String?
    var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case reviewId = "id"
        case author = "author"
        case authorDetail = "author_details"
        case content = "content"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    static func == (lhs: ReviewInfo, rhs: ReviewInfo) -> Bool {
        lhs.id == rhs.id
    }
}
