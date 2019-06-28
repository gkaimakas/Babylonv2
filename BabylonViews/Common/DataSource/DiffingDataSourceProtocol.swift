//
//  Diffing.swift
//  BabylonViews
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import DifferenceKit
import ReactiveSwift

public protocol DiffingDataSourceProtocol: class {
    associatedtype Section: Differentiable
    associatedtype Value: Differentiable
    
    var didUpdateData: Signal<[ArraySection<Section, Value>], Never> { get }
    var sections: [Section] { get }
    
    func update(data newValue: [ArraySection<Section, Value>])
    
    func numberOfSections() -> Int
    func value(forSection: Int) -> Section
    func numberOfObjects(inSection section: Int) -> Int
    func value(atIndexPath indexPath: IndexPath) -> Value
}

public class DiffingDataSource<Section: Differentiable, Value: Differentiable>: NSObject, DiffingDataSourceProtocol {
    let innerData: Atomic<[ArraySection<Section, Value>]>
    
    let didUpdateDataObserver: Signal<[ArraySection<Section, Value>], Never>.Observer
    public let didUpdateData: Signal<[ArraySection<Section, Value>], Never>
    
    public init(initialData: [ArraySection<Section, Value>] = []) {
        innerData = Atomic(initialData)
        (didUpdateData, didUpdateDataObserver) = Signal.pipe()
        super.init()
    }
    
    public func update(data newValue: [ArraySection<Section, Value>]) {
        innerData.swap(newValue)
        didUpdateDataObserver.send(value: newValue)
    }
    
    public var data: [ArraySection<Section, Value>] {
        return innerData
            .value
    }
    
    public var sections: [Section] {
        return innerData
            .value
            .map { $0.model }
    }
    
    /// The number of sections in the diff calculator.
    public func numberOfSections() -> Int {
        return innerData
            .value
            .count
    }
    
    /// The section at a given index.
    public func value(forSection: Int) -> Section {
        return innerData
            .value[forSection]
            .model
    }
    
    /// The number of objects in a given section.
    public func numberOfObjects(inSection section: Int) -> Int {
        return innerData
            .value[section]
            .elements
            .count
    }
    
    /// The value at a given index path.
    public func value(atIndexPath indexPath: IndexPath) -> Value {
        return innerData
            .value[indexPath.section]
            .elements[indexPath.row]
    }
    
    public func isLast(row: Value, at section: Int) -> Bool {
        guard let lastElement = innerData.value[section].elements.last else {
            return false
        }
        
        return lastElement.isContentEqual(to: row)
    }
}
