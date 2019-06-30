//
//  CommentMO.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation

class CommentMO: NSManagedObject {
    static func requestFetchAllComments() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        return request
    }

    static func requestFetchComment(id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.predicate = NSPredicate(format: "id == \(id)")
        return request
    }
    
    static func requestFetchComments(postId: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.predicate = NSPredicate(format: "postId == \(postId)")
        return request
    }
    
    @NSManaged public var postId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var body: String?
    
    func inflate(comment: Comment) {
        self.postId = Int64(comment.postId)
        self.id = Int64(comment.id)
        self.name = comment.name
        self.email = comment.email
        self.body = comment.body
    }
}
