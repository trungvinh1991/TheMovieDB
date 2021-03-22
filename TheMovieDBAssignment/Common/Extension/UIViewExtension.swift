//
//  UIViewExtension.swift
//  PEAX
//
//  Created by Vinh Trung Ly on 19/01/2021.
//

import UIKit
import MBProgressHUD

public extension UIView {
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//    
//    func shake(count :Float = 2,for duration :TimeInterval = 0.3, withTranslation translation :Float = 5) {
//        layer.removeAllAnimations()
//        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//        animation.repeatCount = count
//        animation.duration = duration/TimeInterval(animation.repeatCount)
//        animation.autoreverses = true
//        animation.values = [translation, -translation]
//        layer.add(animation, forKey: "shake")
//    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
//    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderColor: UIColor? {
//        get {
//            let color = UIColor.init(cgColor: layer.borderColor!)
//            return color
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowColor = UIColor.black.cgColor
//            layer.shadowOffset = CGSize(width: 0, height: 2)
//            layer.shadowOpacity = 0.4
//            layer.shadowRadius = newValue
//        }
//    }
    
}

//MARK : MBProgressHUD

public protocol UIViewMBProgressHUD {
    var progressHUD: MBProgressHUD? {get set}
    var hudRetainCount: Int {get set}
}

extension UIView: UIViewMBProgressHUD {
    public var progressHUD: MBProgressHUD? {
        get {
            return self.contextInfo["progressHUD"] as? MBProgressHUD
        }
        set {
            self.contextInfo["progressHUD"] = newValue
        }
    }
    
    public var hudRetainCount: Int {
        get {
            return self.contextInfo["hudRetainCount"] as? Int ?? 0
        }
        set {
            self.contextInfo["hudRetainCount"] = newValue
        }
    }
    
    func showProgressHUD(animated: Bool) {
        self.hudRetainCount += 1
        let progressHUD = self.progressHUD ?? MBProgressHUD(view: self)
        progressHUD.backgroundView.backgroundColor = .none
        self.addSubview(progressHUD)
        progressHUD.show(animated: animated)
        self.progressHUD = progressHUD
    }
    
    func hideProgressHUD(animated: Bool) {
        self.hudRetainCount -= 1
        self.hudRetainCount = max(self.hudRetainCount, 0)
        if self.hudRetainCount <= 0 {
            self.progressHUD?.hide(animated: true)
        }
    }
}
