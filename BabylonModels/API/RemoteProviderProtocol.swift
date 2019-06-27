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
    init(sessionManager: SessionManager)
}


public class RemoteProvider: RemoteProviderProtocol {
    public let sessionManager: SessionManager
    
    required public init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
}
