//
//  TestHomeInteractor.swift
//  TheMovieDBAssignmentTests
//
//  Created by Vinh Ly on 20/03/2021.
//

import XCTest
import Combine
@testable import TheMovieDBAssignment

class TestHomeInteractor: XCTestCase {
    var mockHomeRepo: MockHomeRepository!
    var homeInteractor: HomeInteractor!
    
    var disposeBag = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTrendingSuccess() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)
        var data: MovieResponse!
        
        //Trending list
        mockHomeRepo.homeMovieListType = .trending
        data = mockHomeRepo.responseMovie
        
        homeInteractor.trendingPublisher
            .sink { _ in
                
            } receiveValue: {[weak self] (response) in
                XCTAssertNotNil(response)
                XCTAssertTrue(self?.mockHomeRepo.isHaveError == false)
                
                XCTAssertTrue(response.page == data?.page)
                
                if response.movies.count > 0 {
                    XCTAssertTrue(response.movies.count == data?.movies.count)
                    XCTAssertTrue(response.movies[0].originalTitle == data?.movies[0].originalTitle)
                    XCTAssertTrue(response.movies[1].originalTitle == data?.movies[1].originalTitle)
                    XCTAssertTrue(response.movies[2].originalTitle == data?.movies[2].originalTitle)
                    XCTAssertTrue(response.movies[3].originalTitle == data?.movies[3].originalTitle)
                    XCTAssertTrue(response.movies[4].originalTitle == data?.movies[4].originalTitle)
                    XCTAssertTrue(response.movies[0].posterPath == data?.movies[0].posterPath)
                    XCTAssertTrue(response.movies[1].posterPath == data?.movies[1].posterPath)
                    XCTAssertTrue(response.movies[2].posterPath == data?.movies[2].posterPath)
                    XCTAssertTrue(response.movies[3].posterPath == data?.movies[3].posterPath)
                    XCTAssertTrue(response.movies[4].posterPath == data?.movies[4].posterPath)
                }
                
            }
            .store(in: &disposeBag)
        homeInteractor.getTrendingList()
        
    }
    
    func testTrendingFailed() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)

        //Trending list
        mockHomeRepo.homeMovieListType = .trending
        mockHomeRepo.isHaveError = true
        
        homeInteractor.trendingPublisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    XCTAssertTrue(self?.mockHomeRepo.isHaveError == true)
                default:
                    break
                }
            } receiveValue: { _ in
            }
            .store(in: &disposeBag)
        
        homeInteractor.getTrendingList()
        
    }
    
    func testCategorySuccess() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)
        var data: MovieResponse!
        
        //Trending list
        mockHomeRepo.homeMovieListType = .category
        data = mockHomeRepo.responseMovie
        
        homeInteractor.categoryPublisher
            .sink { _ in
                
            } receiveValue: {[weak self] (response) in
                XCTAssertNotNil(response)
                XCTAssertTrue(self?.mockHomeRepo.isHaveError == false)
                
                XCTAssertTrue(response.page == data?.page)
                
                if response.movies.count > 0 {
                    XCTAssertTrue(response.movies.count == data?.movies.count)
                    XCTAssertTrue(response.movies[0].originalTitle == data?.movies[0].originalTitle)
                    XCTAssertTrue(response.movies[1].originalTitle == data?.movies[1].originalTitle)
                    XCTAssertTrue(response.movies[2].originalTitle == data?.movies[2].originalTitle)
                    XCTAssertTrue(response.movies[3].originalTitle == data?.movies[3].originalTitle)
                }
                
            }
            .store(in: &disposeBag)
        
        homeInteractor.getCategoryList()
        
    }
    
    func testCategoryFailed() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)

        //Trending list
        mockHomeRepo.homeMovieListType = .category
        mockHomeRepo.isHaveError = true
        
        homeInteractor.categoryPublisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    XCTAssertTrue(self?.mockHomeRepo.isHaveError == true)
                default:
                    break
                }
            } receiveValue: { _ in
            }
            .store(in: &disposeBag)
        
        homeInteractor.getCategoryList()
        
    }
    
    func testPopularSuccess() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)
        var data: MovieResponse!
        
        //Trending list
        mockHomeRepo.homeMovieListType = .popular
        data = mockHomeRepo.responseMovie
        
        homeInteractor.popularPublisher
            .sink { _ in
                
            } receiveValue: {[weak self] (response) in
                XCTAssertNotNil(response)
                XCTAssertTrue(self?.mockHomeRepo.isHaveError == false)
                
                XCTAssertTrue(response.page == data.page)
                
                if response.movies.count > 0 {
                    XCTAssertTrue(response.movies.count == data?.movies.count)
                    XCTAssertTrue(response.movies[0].originalTitle == data?.movies[0].originalTitle)
                    XCTAssertTrue(response.movies[1].originalTitle == data?.movies[1].originalTitle)
                    XCTAssertTrue(response.movies[2].originalTitle == data?.movies[2].originalTitle)
                    XCTAssertTrue(response.movies[3].originalTitle == data?.movies[3].originalTitle)
                    XCTAssertTrue(response.movies[4].originalTitle == data?.movies[4].originalTitle)
                    XCTAssertTrue(response.movies[0].posterPath == data?.movies[0].posterPath)
                    XCTAssertTrue(response.movies[1].posterPath == data?.movies[1].posterPath)
                    XCTAssertTrue(response.movies[2].posterPath == data?.movies[2].posterPath)
                    XCTAssertTrue(response.movies[3].posterPath == data?.movies[3].posterPath)
                    XCTAssertTrue(response.movies[4].posterPath == data?.movies[4].posterPath)
                }
                
            }
            .store(in: &disposeBag)
        homeInteractor.getPopularList(loadMore: true)
        
    }
    
    func testPopularFailed() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)
        
        //Trending list
        mockHomeRepo.homeMovieListType = .category
        mockHomeRepo.isHaveError = true
        
        homeInteractor.popularPublisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    XCTAssertTrue(self?.mockHomeRepo.isHaveError == true)
                default:
                    break
                }
            } receiveValue: { _ in
            }
            .store(in: &disposeBag)
        
        homeInteractor.getPopularList(loadMore: false)
        
    }
    
    func testTopRatedSuccess() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)
        var data: MovieResponse!
        
        //Trending list
        mockHomeRepo.homeMovieListType = .topRated
        data = mockHomeRepo.responseMovie
        
        homeInteractor.topRatedPublisher
            .sink { _ in
                
            } receiveValue: {[weak self] (response) in
                XCTAssertNotNil(response)
                XCTAssertTrue(self?.mockHomeRepo.isHaveError == false)
                
                XCTAssertTrue(response.page == data?.page)
                
                if response.movies.count > 0 {
                    XCTAssertTrue(response.movies.count == data?.movies.count)
                    XCTAssertTrue(response.movies[0].originalTitle == data?.movies[0].originalTitle)
                    XCTAssertTrue(response.movies[1].originalTitle == data?.movies[1].originalTitle)
                    XCTAssertTrue(response.movies[2].originalTitle == data?.movies[2].originalTitle)
                    XCTAssertTrue(response.movies[3].originalTitle == data?.movies[3].originalTitle)
                    XCTAssertTrue(response.movies[4].originalTitle == data?.movies[4].originalTitle)
                    XCTAssertTrue(response.movies[0].posterPath == data?.movies[0].posterPath)
                    XCTAssertTrue(response.movies[1].posterPath == data?.movies[1].posterPath)
                    XCTAssertTrue(response.movies[2].posterPath == data?.movies[2].posterPath)
                    XCTAssertTrue(response.movies[3].posterPath == data?.movies[3].posterPath)
                    XCTAssertTrue(response.movies[4].posterPath == data?.movies[4].posterPath)
                }
                
            }
            .store(in: &disposeBag)
        homeInteractor.getTopRatedList(loadMore: true)
        
    }
    
    func testTopRatedFailed() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)

        //Trending list
        mockHomeRepo.homeMovieListType = .topRated
        mockHomeRepo.isHaveError = true
        
        homeInteractor.topRatedPublisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    XCTAssertTrue(self?.mockHomeRepo.isHaveError == true)
                default:
                    break
                }
            } receiveValue: { _ in
            }
            .store(in: &disposeBag)
        
        homeInteractor.getTopRatedList(loadMore: false)
        
    }
    
    func testUpcomingSuccess() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)
        var data: MovieResponse!
        
        //Trending list
        mockHomeRepo.homeMovieListType = .upcoming
        data = mockHomeRepo.responseMovie
        
        homeInteractor.upcomingPublisher
            .sink { _ in
                
            } receiveValue: {[weak self] (response) in
                XCTAssertNotNil(response)
                XCTAssertTrue(self?.mockHomeRepo.isHaveError == false)
                
                XCTAssertTrue(response.page == data?.page)
                
                if response.movies.count > 0 {
                    XCTAssertTrue(response.movies.count == data?.movies.count)
                    XCTAssertTrue(response.movies[0].originalTitle == data?.movies[0].originalTitle)
                    XCTAssertTrue(response.movies[1].originalTitle == data?.movies[1].originalTitle)
                    XCTAssertTrue(response.movies[2].originalTitle == data?.movies[2].originalTitle)
                    XCTAssertTrue(response.movies[3].originalTitle == data?.movies[3].originalTitle)
                    XCTAssertTrue(response.movies[4].originalTitle == data?.movies[4].originalTitle)
                    XCTAssertTrue(response.movies[0].posterPath == data?.movies[0].posterPath)
                    XCTAssertTrue(response.movies[1].posterPath == data?.movies[1].posterPath)
                    XCTAssertTrue(response.movies[2].posterPath == data?.movies[2].posterPath)
                    XCTAssertTrue(response.movies[3].posterPath == data?.movies[3].posterPath)
                    XCTAssertTrue(response.movies[4].posterPath == data?.movies[4].posterPath)
                }
                
            }
            .store(in: &disposeBag)
        homeInteractor.getUpcomingList(loadMore: true)
        
    }
    
    func testUpcomingFailed() throws {
        mockHomeRepo = MockHomeRepository()
        homeInteractor = HomeInteractorImpl(repository: mockHomeRepo)

        //Trending list
        mockHomeRepo.homeMovieListType = .upcoming
        
        homeInteractor.upcomingPublisher
            .sink {[weak self] (completion) in
                switch completion {
                case .failure(_):
                    XCTAssertTrue(self?.mockHomeRepo.isHaveError == true)
                default:
                    break
                }
            } receiveValue: { _ in
            }
            .store(in: &disposeBag)
        mockHomeRepo.isHaveError = true
        homeInteractor.getUpcomingList(loadMore: false)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
