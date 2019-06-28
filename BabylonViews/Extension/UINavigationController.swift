//
//  UINavigationController.swift
//  BabylonViews
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

extension Reactive where Base: UINavigationController {
    public func push(animated: Bool = true) -> BindingTarget<UIViewController> {
        return makeBindingTarget({ (nav, controller) in
            nav.pushViewController(controller, animated: animated)
        })
    }
}
