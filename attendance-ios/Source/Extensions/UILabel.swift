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
}
