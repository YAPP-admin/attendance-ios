//
//  UILabelWithRound.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/02/21.
//

import Foundation
import UIKit

class UILabelWithRound: UILabel {
    let borderColor: CGColor
    let borderWidth: CGFloat
    let inset: UIEdgeInsets
    init(frame: CGRect = .zero, color: CGColor = UIColor.gray.cgColor, width: CGFloat = 1, inset: UIEdgeInsets = .zero) {
        borderColor = color
        borderWidth = width
        self.inset = inset
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = 8
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor
            clipsToBounds = true
        }
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += self.inset.left + self.inset.right
        size.height += self.inset.top + self.inset.bottom
        return size
    }
}
