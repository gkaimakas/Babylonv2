//
//  PostListViewController+Section.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViewModels
import DifferenceKit

extension PostListViewController {
    enum Section {
        case none
        
        var id: String {
            switch self {
            case .none:
                return "none"
            }
        }
    }
}

extension PostListViewController.Section: Equatable {
    static func ==(lhs: PostListViewController.Section, rhs: PostListViewController.Section) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PostListViewController.Section: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PostListViewController.Section: CustomStringConvertible {
    var description: String {
        return id
    }
}

extension PostListViewController.Section: Differentiable {
    var differenceIdentifier: String {
        return id
    }
}
