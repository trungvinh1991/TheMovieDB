//
//  MovieDBProviderTest.swift
//  TheMovieDBAssignmentTests
//
//  Created by Vinh Ly on 19/03/2021.
//

import XCTest

@testable import TheMovieDBAssignment

class MovieDBProviderTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTrendListProvider() throws {
        let trend = MovieDBProvider.trending
        XCTAssertTrue(trend.domain == "https://api.themoviedb.org")
        XCTAssertTrue(trend.headers["Content-Type"] == "application/json;charset=utf-8")
        XCTAssertTrue(trend.method == "GET")
        XCTAssertTrue(trend.url == "https://api.themoviedb.org/3/trending/all/day")
    }
    
    func testPopularListProvider() throws {
        let page = 3
        let trend = MovieDBProvider.popular(page)
        XCTAssertTrue(trend.domain == "https://api.themoviedb.org")
        XCTAssertTrue(trend.headers["Content-Type"] == "application/json;charset=utf-8")
        XCTAssertTrue(trend.method == "GET")
        XCTAssertTrue(trend.url == "https://api.themoviedb.org/3/movie/popular")
        XCTAssertTrue(trend.params["page"] == String(page))
    }
    
    func testTopRatedListProvider() throws {
        let page = 10
        let trend = MovieDBProvider.topRated(page)
        XCTAssertTrue(trend.domain == "https://api.themoviedb.org")
        XCTAssertTrue(trend.headers["Content-Type"] == "application/json;charset=utf-8")
        XCTAssertTrue(trend.method == "GET")
        XCTAssertTrue(trend.url == "https://api.themoviedb.org/3/movie/top_rated")
        XCTAssertTrue(trend.params["page"] == String(page))
    }
    
    func testUpcomingListProvider() throws {
        let page = 1000
        let trend = MovieDBProvider.upcoming(page)
        XCTAssertTrue(trend.domain == "https://api.themoviedb.org")
        XCTAssertTrue(trend.headers["Content-Type"] == "application/json;charset=utf-8")
        XCTAssertTrue(trend.method == "GET")
        XCTAssertTrue(trend.url == "https://api.themoviedb.org/3/movie/upcoming")
        XCTAssertTrue(trend.params["page"] == String(page))
    }
    
    func testPosterUrlProvider() throws {
        let posterPath = "myPath"
        let trend = MovieDBProvider.poster(posterPath)
        XCTAssertTrue(trend.domain == "https://image.tmdb.org/t/p/original/")
        XCTAssertTrue(trend.headers["Content-Type"] == "application/json;charset=utf-8")
        XCTAssertTrue(trend.method == "GET")
        XCTAssertTrue(trend.url.contains("https://image.tmdb.org/t/p/original/" + posterPath))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
