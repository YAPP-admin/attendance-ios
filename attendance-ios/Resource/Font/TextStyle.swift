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
    case Subhead1
    case Subhead2
	case Body1
	case Body2
    case Caption1
}

extension TextStyle {
    var font: UIFont {
        switch self {
        case .H1:
            return UIFont.Pretendard(type: .bold, size: 24)
        case .H3:
            return UIFont.Pretendard(type: .semiBold, size: 18)
        case .Subhead1:
            return UIFont.Pretendard(type: .semiBold, size: 16)
        case .Subhead2:
            return UIFont.Pretendard(type: .semiBold, size: 14)
		case .Body1:
			return UIFont.Pretendard(type: .medium, size: 16)
		case .Body2:
			return UIFont.Pretendard(type: .medium, size: 14)
        case .Caption1:
            return UIFont.Pretendard(type: .medium, size: 12)
        }
    }
}
