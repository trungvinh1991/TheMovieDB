//
//  UIColorExtension.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 18/03/2021.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
