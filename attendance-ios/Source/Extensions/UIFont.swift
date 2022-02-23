//
//  UIFont.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/02/22.
//

import UIKit

extension UIFont {
    class func Pretendard(type: PretendardType, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.name, size: size) else { return UIFont() }
        return font
    }
    
    public enum PretendardType {
        case Bold
        case Medium
        
        var name: String {
            switch self {
            case .Bold:
                return "Pretendard-Bold"
            case .Medium:
                return "Pretendard-Medium"
            }
        }
    }
}
