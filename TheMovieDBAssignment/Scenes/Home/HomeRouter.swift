//
//  HomeRouter.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import UIKit

protocol HomeRouter {
    func moveToMovieDetail(currentView: UIViewController, movie: MovieInfo)
}

final class HomeRouterImpl: HomeRouter {
    func moveToMovieDetail(currentView: UIViewController, movie: MovieInfo) {
        let interactor = MovieDetailInteractorImpl(repository: MovieDetailRepositoryImpl(), movieInfo: movie)
        let presenter = MovieDetailPresenterImpl(interactor: interactor, movie: movie)
        let movieDetailView = MovieDetailViewController(presenter: presenter)
        
        currentView.navigationController?.pushViewController(movieDetailView, animated: true)
    }
}
