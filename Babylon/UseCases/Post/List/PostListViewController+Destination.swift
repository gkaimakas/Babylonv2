//
//  PostListViewController+Destination.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViewModels
import ReactiveSwift
import UIKit

extension PostListViewController {
    enum Destination {
        case postDetails(PostViewModel)
    }
}

extension PostListViewController.Destination {
    static func navigateTo() -> Action<PostListViewController.Destination, UIViewController, Never> {
        return Action.empty
    }
}
