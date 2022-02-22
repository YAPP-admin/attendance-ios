//
//  TextStyle.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/02/22.
//

import UIKit

enum TextStyle {
    case H1
    case H3
    case Body1
    case Body2
    case Caption1
}

extension TextStyle {
    var font: UIFont {
        switch self {
        case .H1:
            return UIFont.Pretendard(type: .Bold, size: 24)
        case .H3:
            return UIFont.Pretendard(type: .Medium, size: 18)
        case .Body1:
            return UIFont.Pretendard(type: .Medium, size: 16)
        case .Body2:
            return UIFont.Pretendard(type: .Medium, size: 14)
        case .Caption1:
            return UIFont.Pretendard(type: .Medium, size: 12)
        }
    }
}
