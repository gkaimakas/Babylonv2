//
//  PostTableViewCell.swift
//  BabylonViews
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonViewModels
import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

public protocol PostTableViewCellDriver: class {
    var title: Property<String?> { get }
    var body: Property<String?> { get }
}

public final class PostTableViewCell: UITableViewCell {
    public let titleLabel = UILabel(frame: .zero)
    public let bodyLabel = UILabel(frame: .zero)
    
    weak var driver: PostTableViewCellDriver?
    
    override public init(style: UITableViewCell.CellStyle,
                         reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(4)
            make.bottom.equalTo(bodyLabel.snp.top).offset(-4)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-4)
        }
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 0
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.numberOfLines = 0
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    public func apply(driver: PostTableViewCellDriver) {
        reactive.lifetime += titleLabel.reactive.text <~ driver
            .title
            .producer
            .observe(on: UIScheduler())
            .take(until: reactive.prepareForReuse)
        
        reactive.lifetime += bodyLabel.reactive.text <~ driver
            .body
            .producer
            .observe(on: UIScheduler())
            .take(until: reactive.prepareForReuse)
    }
}

extension PostViewModel: PostTableViewCellDriver {
    
}
