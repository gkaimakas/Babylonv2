//
//  LocalProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Alamofire
import BabylonCommon
import ReactiveSwift

public protocol LocalProviderProtocol: class {
    init(container: DataContainer)
}


public class LocalProvider: LocalProviderProtocol {
    public let container: DataContainer
    
    required public init(container: DataContainer) {
        self.container = container
    }
}
