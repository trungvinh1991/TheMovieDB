//
//  NSObjectExtension.swift
//  PEAX
//
//  Created by Vinh Trung Ly on 02/02/2021.
//

import Foundation

protocol ContextInfo : NSObjectProtocol {
    var contextInfo : Dictionary<AnyHashable, Any> {get set}
}

fileprivate let key = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)

extension NSObject : ContextInfo {
    var contextInfo: Dictionary<AnyHashable, Any> {
        get {

            if let unwrapped : Dictionary<AnyHashable, Any> = objc_getAssociatedObject(self, key) as? Dictionary<AnyHashable, Any> {
                return unwrapped
            } else {
                let result : Dictionary<AnyHashable, Any> = Dictionary()
                objc_setAssociatedObject(self, key, result, .OBJC_ASSOCIATION_RETAIN)
                return result
            }
        }
        
        set {
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
