//
//  PostDetailsViewController.swift
//  Babylon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonCommon
import BabylonViewModels
import BabylonViews
import DifferenceKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit
import UIKit

class PostDetailsViewController: UIViewController {
    let tableView: UITableView
    let refreshControl: UIRefreshControl
    let dataSource: UITableViewDiffingDataSource<Section, Row>
    let presenter: Presenter

    var viewModel: PostViewModel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .grouped)
        refreshControl = UIRefreshControl()
        dataSource = UITableViewDiffingDataSource(tableView: tableView)
        presenter = Presenter(tableView: tableView,
                              dataSource: dataSource)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        tableView = UITableView(frame: .zero, style: .grouped)
        refreshControl = UIRefreshControl()
        dataSource = UITableViewDiffingDataSource(tableView: tableView)
        presenter = Presenter(tableView: tableView,
                              dataSource: dataSource)
        
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindDataSource()
        
        reactive.lifetime += viewModel
            .fetchComments
            .apply(.conditional({ $0.count == 0}))
            .start()
    }
    
    func setupTableView() {
        tableView.addSubview(refreshControl)
        refreshControl.reactive.refresh = CocoaAction(viewModel.forceFetchComments)
    }
    
    func bindDataSource() {
        reactive.lifetime += dataSource.reactive.reload(with: .none) <~ viewModel
            .comments
            .producer
            .filterMap { [weak self] comments -> (PostViewModel, [CommentViewModel])? in
                guard let post = self?.viewModel else {
                    return nil
                }
                return (post, comments)
            }
            .map { (post, comments) -> [ArraySection<Section, Row>] in
                var sections = [
                    ArraySection<Section, Row>(model: .none, elements: [.post(post)])
                ]
                
                if comments.count > 0 {
                    sections.append(ArraySection(model: .none, elements: comments.map { Row.comment($0) }))
                }
                
                return sections
        }
    }
}
