//
//  MovieDBProvider.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Foundation

enum MovieDBProvider: APIProvider {
    static let apiKey = "a7b3c9975791294647265c71224a88ad"
    
    case poster(String)
    case trending
    case popular(Int)
    case topRated(Int)
    case upcoming(Int)
    case movieDetail(Int)
    case cast(Int)
    case videos(Int)
    case reviews(Int,Int)
    case recomendations(Int,Int)
    
    var domain: String {
        switch self {
        case .poster(_):
            return "https://image.tmdb.org/t/p/original/"
        default:
            return "https://api.themoviedb.org"
        }
        
    }
    
    var version: String {
        return "3"
    }
    
    var url: String {
        var urlPath = domain + "/" + version
        switch self {
        case .poster(let imagePath):
            return domain + imagePath + "?api_key=" + MovieDBProvider.apiKey
        case .trending:
            urlPath += "/trending/all/day"
        case .popular(_):
            urlPath += "/movie/popular"
        case .topRated(_):
            urlPath += "/movie/top_rated"
        case .upcoming(_):
            urlPath += "/movie/upcoming"
        case .movieDetail(let movieId):
            urlPath += "/movie/" + String(movieId)
        case .cast(let movieId):
            urlPath += "/movie/\(String(movieId))/credits"
        case .videos(let movieId):
            urlPath += "/movie/\(String(movieId))/lists"
        case .reviews(let movieId, _):
            urlPath += "/movie/\(String(movieId))/reviews"
        case .recomendations(let movieId, _):
            urlPath += "/movie/\(String(movieId))/recommendations"
        }
        return urlPath
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var headers: [String : String] {
        return [
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    var params: [String : String] {
        var params = ["api_key": MovieDBProvider.apiKey]
        switch self {
        case .popular(let page):
            params["page"] = String(page)
        case .topRated(let page):
            params["page"] = String(page)
        case .upcoming(let page):
            params["page"] = String(page)
        case .movieDetail(_):
            break
        case .reviews(_, let page):
            params["page"] = String(page)
        case .recomendations(_, let page):
            params["page"] = String(page)
        default:
            break
        }
        
        return params
    }
    
    
}
