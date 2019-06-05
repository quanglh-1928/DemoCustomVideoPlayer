//
//  AutoLayoutHelper.swift
//  DemoConstraintProgramically
//
//  Created by ly.hoang.quang on 6/3/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import Foundation
import UIKit

class AutoLayoutHelper {
    static let highestPriority: UILayoutPriority = UILayoutPriority(999)
    static let lowestPriority: UILayoutPriority = UILayoutPriority(1)
    
    @discardableResult
    static func center(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            equalConstraint(view, superView: superView, attribute: .centerX),
            equalConstraint(view, superView: superView, attribute: .centerY)
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    static func fit(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            equalConstraint(view, superView: superView, attribute: .top),
            equalConstraint(view, superView: superView, attribute: .left),
            equalConstraint(view, superView: superView, attribute: .right),
            equalConstraint(view, superView: superView, attribute: .bottom)
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    static func sameSize(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            equalConstraint(view, superView:superView, attribute: .width),
            equalConstraint(view, superView:superView, attribute: .height)
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    static func sameWidth(_ view: UIView, superView: UIView, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = equalConstraint(view, superView:superView, attribute: .width, multiplier: multiplier)
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    static func setRatio(_ view: UIView, multiplier: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraint = ratioConstraint(view, multiplier: multiplier)
        NSLayoutConstraint.activate([constraint])
    }
}

extension AutoLayoutHelper {
    static func equalConstraint(_ view: UIView,
                                superView: UIView,
                                attribute: NSLayoutConstraint.Attribute,
                                multiplier: CGFloat = 1.0,
                                constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: multiplier,
                                            constant: constant)
        return constraint
    }
    
    static func constraint(_ view: UIView,
                           attribute atr1: NSLayoutConstraint.Attribute,
                           superView: UIView,
                           attribute atr2: NSLayoutConstraint.Attribute,
                           multiplier: CGFloat = 1.0,
                           constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: atr1,
                                            relatedBy: .equal,
                                            toItem: superView,
                                            attribute: atr2,
                                            multiplier: multiplier,
                                            constant: constant)
        return constraint
    }
    
    static func fixedConstraint(_ view: UIView,
                                attribute: NSLayoutConstraint.Attribute,
                                value: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: value)
        return constraint
    }
    
    static func relatedConstraint(_ view: UIView,
                                  superView: UIView,
                                  attribute: NSLayoutConstraint.Attribute,
                                  relatedBy: NSLayoutConstraint.Relation,
                                  constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: attribute,
                                            relatedBy: relatedBy,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        return constraint
    }
    
    static func ratioConstraint(_ view: UIView,
                                multiplier: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: 0)
        return constraint
    }
}

