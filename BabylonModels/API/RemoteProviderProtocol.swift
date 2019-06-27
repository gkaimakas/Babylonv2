//
//  RemoteProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Alamofire
import BabylonCommon
import ReactiveSwift

public protocol RemoteProviderProtocol: class {
    init(network: Network)
}


public class RemoteProvider: RemoteProviderProtocol {
    public let network: Network
    
    required public init(network: Network) {
        self.network = network
    }
}
