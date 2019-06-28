//
//  ViewController.swift
//  Babylon
//
//  Created by George Kaimakas on 27/06/2019.
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

class PostListViewController: UIViewController {
    let tableView: UITableView
    let refreshControl: UIRefreshControl
    let dataSource: UITableViewDiffingDataSource<Section, Row>
    let presenter: Presenter
    let navigateTo: Action<Destination, UIViewController, Never>
    
    var viewModel: PostListViewModel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .grouped)
        refreshControl = UIRefreshControl()
        dataSource = UITableViewDiffingDataSource(tableView: tableView)
        presenter = Presenter(tableView: tableView,
                              dataSource: dataSource)
        navigateTo = Destination.navigateTo()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        tableView = UITableView(frame: .zero, style: .grouped)
        refreshControl = UIRefreshControl()
        dataSource = UITableViewDiffingDataSource(tableView: tableView)
        presenter = Presenter(tableView: tableView,
                              dataSource: dataSource)
        navigateTo = Destination.navigateTo()
        
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
        
        
        self.viewModel = viewModel ?? UIApplication.inject(PostListViewModel.self)
        
        setupTableView()
        bindDataSource()
        bindInfiniteScrolling()
        
        reactive.lifetime += viewModel
            .fetchPosts
            .apply(.remote)
            .start()
    }
    
    func setupTableView() {
        tableView.addSubview(refreshControl)
        refreshControl.reactive.refresh = CocoaAction(viewModel.forceFetchPosts)
    }
    
    func bindDataSource() {
        reactive.lifetime += dataSource.reactive.reload(with: .automatic) <~ viewModel
            .posts
            .producer
            .observe(on: UIScheduler())
            .skipRepeats()
            .map { list -> [ArraySection<Section, Row>] in
                return list.map { post -> ArraySection<Section, Row> in
                    return ArraySection(model: .none, elements: [.post(post)])
                }
            }
    }
    
    func bindInfiniteScrolling() {
        reactive.lifetime += viewModel.fetchPosts.bindingTarget <~ presenter
            .willDisplayRow
            .map { $0.row }
            .filterMap { [weak self] row -> Bool? in
                return self?.dataSource.isLast(row: row, at: 0)
            }
            .filter { $0 }
            .skipRepeats()
            .map { _ in .remote }
    }
}
