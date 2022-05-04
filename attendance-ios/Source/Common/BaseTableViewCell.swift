//
//  BaseTableViewCell.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/20.
//

import Foundation
import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    var eventBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        eventBag = DisposeBag()
    }
}
