//
//  RootRouter.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import UIKit

protocol RootRouter {
    func makeHomeScreen() -> UIViewController
}

struct RootRouterImpl: RootRouter {
    var navigationController: BaseNavigationController!
    
    func makeHomeScreen() -> UIViewController {
        let homeScreen = HomeViewController(presenter: HomePresenterImpl(interactor: HomeInteractorImpl(repository: HomeRepositoryImpl())))
        
        return homeScreen
    }
}
