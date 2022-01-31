//
//  UILabel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import UIKit

extension UILabel {
    
    func setLineSpacing(_ lineSpacing: CGFloat) {
        guard let labelText = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: labelText)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
