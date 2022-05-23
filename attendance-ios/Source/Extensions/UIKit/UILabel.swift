//
//  UILabel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import UIKit

extension UILabel {

    func setLineSpacing(_ lineSpacing: CGFloat) {
        guard let text = self.text else { return }

        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }

    func setBoldFont(_ targetText: String) {
        guard let fullText = self.text, let font = self.font else { return }

        let attributedString = NSMutableAttributedString(string: fullText)
        let targetRange = (fullText as NSString).range(of: targetText)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: font.pointSize, weight: .bold), range: targetRange)

        self.attributedText = attributedString
    }

    func style(_ textStyle: TextStyle) {
        self.font = textStyle.font
    }

}
