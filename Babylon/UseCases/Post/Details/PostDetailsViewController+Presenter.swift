//
//  PostDetailsViewController+Presenter.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViews
import UIKit

extension PostDetailsViewController {
    class Presenter: TableViewDataPresenter<Section, Row> {
        
        override init(tableView: UITableView,
                      dataSource: UITableViewDiffingDataSource<Section, Row>) {
            
            super.init(tableView: tableView,
                       dataSource: dataSource)
            
            tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
            tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            switch dataSource.value(atIndexPath: indexPath) {
            case let .post(value):
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                         for: indexPath) as! PostTableViewCell
                cell.apply(driver: value)
                return cell
                
            case let .comment(value):
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier,
                                                         for: indexPath) as! CommentTableViewCell
                cell.apply(driver: value)
                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }
}
