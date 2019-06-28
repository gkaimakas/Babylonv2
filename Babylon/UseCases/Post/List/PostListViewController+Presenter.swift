//
//  PostListViewController+Presenter.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViews
import UIKit

extension PostListViewController {
    class Presenter: TableViewDataPresenter<Section, Row> {
        let cell = PostTableViewCell(style: .default, reuseIdentifier: "")
        
        
        override init(tableView: UITableView,
                      dataSource: UITableViewDiffingDataSource<Section, Row>) {
            
            super.init(tableView: tableView,
                       dataSource: dataSource)
            
            tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        }
        
        override func tableView(_ tableView: UITableView,
                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                     for: indexPath) as! PostTableViewCell
            
            switch dataSource.value(atIndexPath: indexPath) {
            case let .post(value):
                cell.apply(driver: value)
            }
            return cell
        }
    }
}
