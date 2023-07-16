//
//  Font.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import SwiftUI

extension Font {
    
    static let YPCaption1: Font = .YPFont(type: .medium, size: 12)
    static let YPBody2: Font = .YPFont(type: .medium, size: 14)
    static let YPBody1: Font = .YPFont(type: .medium, size: 16)
    static let YPSubHead2: Font = .YPFont(type: .semiBold, size: 14)
    static let YPSubHead1: Font = .YPFont(type: .semiBold, size: 16)
    static let YPHead2: Font = .YPFont(type: .semiBold, size: 18)
    static let YPHead1: Font = .YPFont(type: .bold, size: 24)
    
    static func YPFont(type: PretendardType, size: CGFloat) -> Font {
        return Font.custom(type.name, size: size+1)
    }

    public enum PretendardType {
        case regular
        case medium
        case semiBold
        case bold

        var name: String {
            switch self {
            case .regular:
                return "Pretendard-Regular"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .bold:
                return "Pretendard-Bold"
            }
        }
    }
}
