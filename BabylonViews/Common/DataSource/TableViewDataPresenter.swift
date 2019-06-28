//
//  TableViewDataPresenter.swift
//  BabylonViews
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import DifferenceKit
import ReactiveSwift
import UIKit

open class TableViewDataPresenter<Section, Row>: NSObject, UITableViewDataSource, UITableViewDelegate where Section: Differentiable, Row: Differentiable {
    public typealias WillDisplayRowEvent = (cell: UITableViewCell, index: IndexPath, row: Row)
    public typealias WillDisplayFooterViewEvent = (view: UIView, section: Int, section: Section)
    public typealias DidSelectRowEvent = (index: IndexPath, row: Row)
    
    unowned public var tableView: UITableView
    unowned public var dataSource: UITableViewDiffingDataSource<Section, Row>
    
    let willDisplayRowObserver: Signal<WillDisplayRowEvent, Never>.Observer
    public let willDisplayRow: Signal<WillDisplayRowEvent, Never>
    
    let willDisplayFooterViewObserver: Signal<WillDisplayFooterViewEvent, Never>.Observer
    public let willDisplayFooterView: Signal<WillDisplayFooterViewEvent, Never>
    
    let didSelectRowObserver: Signal<DidSelectRowEvent, Never>.Observer
    public let didSelectRow: Signal<DidSelectRowEvent, Never>
    
    public init(tableView: UITableView, dataSource: UITableViewDiffingDataSource<Section, Row>) {
        self.tableView = tableView
        self.dataSource = dataSource
        
        (willDisplayRow, willDisplayRowObserver) = Signal.pipe()
        (willDisplayFooterView, willDisplayFooterViewObserver) = Signal.pipe()
        (didSelectRow, didSelectRowObserver) = Signal.pipe()
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfObjects(inSection: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError()
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.willDisplayRowObserver.send(value: (cell: cell,
                                                     index: indexPath,
                                                     row: self.dataSource.value(atIndexPath: indexPath)))
        }
    }
    
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooterViewObserver.send(value: (view, section, dataSource.value(forSection: section)))
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.didSelectRowObserver.send(value: (index: indexPath,
                                                   row: self.dataSource.value(atIndexPath: indexPath)))
        }
    }
}
