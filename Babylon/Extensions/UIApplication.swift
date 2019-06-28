//
//  UIApplication.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import UIKit

extension UIApplication {
    static var appDelegate: AppDelegate? {
        return shared.appDelegate
    }
    
    var appDelegate: AppDelegate? {
        return self.delegate as? AppDelegate
    }
    
    static func inject<T>(_ type: T.Type) -> T {
        guard let delegate = appDelegate,
            let object = delegate.dependencyContainer.resolve(type) else {
                    fatalError("Could not inject \(T.self)")
        }
        
        return object
    }
}
