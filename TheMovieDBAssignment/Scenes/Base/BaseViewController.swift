//
//  BaseViewController.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import UIKit

class BaseViewController: UIViewController {

    func setInifiniteScroll(scrollView: UIScrollView, isInfiniteScroll: Bool, infiniteRefresh: (() -> ())?) {
        if isInfiniteScroll {
            scrollView.addInfiniteScrolling(actionHandler: {
                infiniteRefresh?()
            })
        }
    }
    
    func setPullToRefresh(scrollView: UIScrollView, isPullToRefresh: Bool, pullToRefresh: (() -> ())?) {
        if isPullToRefresh {
            scrollView.addPullToRefresh(actionHandler: {
                pullToRefresh?()
            })
            scrollView.pullToRefreshView.isHidden = true
        }
    }
    
    func stopRefreshAnimating(scrollView: UIScrollView) {
        if scrollView.infiniteScrollingView != nil && scrollView.infiniteScrollingView.state == .loading {
            scrollView.infiniteScrollingView.stopAnimating()
        }
        if scrollView.pullToRefreshView != nil && scrollView.pullToRefreshView.state == .loading {
            scrollView.pullToRefreshView.stopAnimating()
        }
    }

}
