//
//  PostDetailsViewController+Section.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViewModels
import DifferenceKit

extension PostDetailsViewController {
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

extension PostDetailsViewController.Section: Equatable {
    static func ==(lhs: PostDetailsViewController.Section, rhs: PostDetailsViewController.Section) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PostDetailsViewController.Section: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PostDetailsViewController.Section: CustomStringConvertible {
    var description: String {
        return id
    }
}

extension PostDetailsViewController.Section: Differentiable {
    var differenceIdentifier: String {
        return id
    }
}
