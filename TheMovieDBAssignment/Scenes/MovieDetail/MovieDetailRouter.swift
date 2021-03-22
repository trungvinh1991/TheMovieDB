//
//  MovieDetailRouter.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import UIKit

protocol MovieDetailRouter {
    func backToPreviousScreen(currentView: UIViewController)
}

final class MovieDetailRouterImpl: MovieDetailRouter {
    func backToPreviousScreen(currentView: UIViewController) {
        currentView.navigationController?.popViewController(animated: true)
    }
}
