//
//  ErrorInfo.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Foundation

struct ErrorInfo: Error {
    var statusCode: Int = 0
    var errorTitle: String?
    var errorDescription: String?
}
