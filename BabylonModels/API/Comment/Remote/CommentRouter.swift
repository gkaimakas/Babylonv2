//
//  CommentRouter.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Alamofire
import Foundation

enum CommentRouter {
    case fetchComments(postId: Int)
    case fetchComment(id: Int)
}

extension CommentRouter: URLRequestConvertible {
    var httpMethod: Alamofire.HTTPMethod {
        return .get
    }
    
    var encoding: Alamofire.ParameterEncoding {
        return URLEncoding.default
    }
    
    var requestConfiguration: (path: String, parameters: [String: AnyObject]?) {
        switch self {
            
        case .fetchComments(let postId):
            return (
                path: "http://jsonplaceholder.typicode.com/posts/\(postId)/comments",
                parameters: nil
            )
            
        case .fetchComment(let id):
            return (
                path: "http://jsonplaceholder.typicode.com/comments/\(id)",
                parameters: nil
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let result = self.requestConfiguration
        
        let url = Foundation.URL(string: result.path)!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = self.httpMethod.rawValue
        
        let request = try encoding.encode(urlRequest, with: result.parameters)
        return request
    }
}
