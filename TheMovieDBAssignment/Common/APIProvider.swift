//
//  APIProvider.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 19/03/2021.
//

import Foundation

protocol APIProvider: Equatable {
    var domain: String { get }
    var version: String { get }
    var url: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var params: [String: String] { get }
}
