//
//  PostListViewController+Row.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViewModels
import DifferenceKit

extension PostListViewController {
    enum Row {
        case post(PostViewModel)
        
        var id: String {
            switch self {
            case let .post(value):
                return "post-\(value.id.value)-\(value.hashValue)"
            }
        }
    }
}

extension PostListViewController.Row: Equatable {
    static func ==(lhs: PostListViewController.Row, rhs: PostListViewController.Row) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PostListViewController.Row: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PostListViewController.Row: CustomStringConvertible {
    var description: String {
        return id
    }
}

extension PostListViewController.Row: Differentiable {
    var differenceIdentifier: String {
        return id
    }
}
