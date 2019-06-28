//
//  CommentTableViewCell.swift
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

public protocol CommentTableViewCellDriver: class {
    var name: Property<String?> { get }
    var body: Property<String?> { get }
}

public final class CommentTableViewCell: UITableViewCell {
    public let bodyLabel = UILabel(frame: .zero)
    public let nameLabel = UILabel(frame: .zero)
    
    weak var driver: CommentTableViewCellDriver?
    
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
        contentView.addSubview(bodyLabel)
        contentView.addSubview(nameLabel)
        
        bodyLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(4)
            make.bottom.equalTo(nameLabel.snp.top).offset(-8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-4)
        }
        
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .callout).lineHeight)
        nameLabel.textColor = .darkText
        nameLabel.numberOfLines = 0
        
        selectionStyle = .none
    }
    
    public func apply(driver: CommentTableViewCellDriver) {
        reactive.lifetime += nameLabel.reactive.text <~ driver
            .name
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

extension CommentViewModel: CommentTableViewCellDriver { }
