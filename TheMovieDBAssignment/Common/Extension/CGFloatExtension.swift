//
//  CGFloatExtension.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 18/03/2021.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
