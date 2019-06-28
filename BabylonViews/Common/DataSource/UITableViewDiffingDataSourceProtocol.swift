//
//  UITableViewDiffinDataSource.swift
//  BabylonViews
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import DifferenceKit
import ReactiveCocoa
import ReactiveSwift
import Foundation

public protocol UITableViewDiffingDataSourceProtocol: class {
    associatedtype Section: Differentiable
    associatedtype Value: Differentiable
    
    func reload(using newData: [ArraySection<Section, Value>], with animation: UITableView.RowAnimation, skipRepeats: Bool)
}

public class UITableViewDiffingDataSource<Section: Differentiable, Value: Differentiable>: DiffingDataSource<Section, Value>, UITableViewDiffingDataSourceProtocol {
    weak var tableView: UITableView!
    
    public init(tableView: UITableView!, initialData: [ArraySection<Section, Value>] = []) {
        self.tableView = tableView
        super.init(initialData: initialData)
    }
    
    public func reload(using newData: [ArraySection<Section, Value>],
                       with animation: UITableView.RowAnimation,
                       skipRepeats: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            let oldData = self.innerData.value
            let changeSet = StagedChangeset(source: oldData, target: newData)
            
            if skipRepeats == true {
                let oldId = oldData.map({ (section) -> String in return "\(section.model.differenceIdentifier)" + section.elements.map { "\($0.differenceIdentifier)" }.joined() }).joined()
                let newId = newData.map({ (section) -> String in return "\(section.model.differenceIdentifier)" + section.elements.map { "\($0.differenceIdentifier)" }.joined() }).joined()
                
                if oldId == newId {
                    return
                }
            }
            
            self.tableView.reload(using: changeSet,
                                  with: animation) { [weak self] (value) in
                                    self?.update(data: value)
            }
        }
    }
}

extension Reactive where Base: UITableViewDiffingDataSourceProtocol {
    public func reload(with animation: UITableView.RowAnimation, skipRepeats: Bool = true) -> BindingTarget<[ArraySection<Base.Section, Base.Value>]> {
        
        return makeBindingTarget({ (base, data) in
            base.reload(using: data, with: animation, skipRepeats: skipRepeats)
        })
    }
}
