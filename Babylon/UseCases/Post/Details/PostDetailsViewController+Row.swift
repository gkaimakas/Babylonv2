//
//  PostDetailsViewController+Row.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViewModels
import DifferenceKit

extension PostDetailsViewController {
    enum Row {
        case post(PostViewModel)
        case comment(CommentViewModel)
        
        var id: String {
            switch self {
            case let .post(value):
                return "post-\(value.id.value)-\(value.hashValue)"
            case let .comment(value):
                return "comment-\(value.id.value)-\(value.hashValue)"
            }
        }
    }
}

extension PostDetailsViewController.Row: Equatable {
    static func ==(lhs: PostDetailsViewController.Row, rhs: PostDetailsViewController.Row) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PostDetailsViewController.Row: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PostDetailsViewController.Row: CustomStringConvertible {
    var description: String {
        return id
    }
}

extension PostDetailsViewController.Row: Differentiable {
    var differenceIdentifier: String {
        return id
    }
}
