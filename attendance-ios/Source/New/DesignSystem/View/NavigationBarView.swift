//
//  NavigationBarView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/13.
//

import SwiftUI

struct NavigationBarView: View {
    
    public enum NaviType: Equatable {
        public static func == (lhs: NavigationBarView.NaviType, rhs: NavigationBarView.NaviType) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none):
                return true
            case (.dismiss, .dismiss):
                return true
            case (.pop, .pop):
                return true
            default:
                return false
            }
        }
        
        case none
        case dismiss(tintColor: Color = .gray_800, onDismiss: () -> Void)
        case pop(tintColor: Color = .gray_800, onDismiss: () -> Void)
    }
    
    public struct ButtonOption: Identifiable {
        
        public let id: String
        public let image: Image
        public let tintColor: Color
        public let touchUpInside: () -> ()
        
        public init(
            image: Image,
            tintColor: Color,
            touchUpInside: @escaping () -> ()
        ) {
            self.id = UUID().uuidString
            self.image = image
            self.tintColor = tintColor
            self.touchUpInside = touchUpInside
        }
    }
    
    public struct TextOption {
        public let string: String
        public let tintColor: Color
        
        public init(
            string: String,
            tintColor: Color = .gray_1200
        ) {
            self.string = string
            self.tintColor = tintColor
        }
    }
    
    private let naviType: NaviType
    private let title: TextOption?
    private let rightButton: ButtonOption?
    
    public init(
        naviType: NaviType,
        title: TextOption? = nil,
        rightButton: ButtonOption? = nil
    ) {
        self.naviType = naviType
        self.title = title
        self.rightButton = rightButton
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            
            if case let .pop(tintColor, onDismiss) = naviType {
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        Image("back")
                            .frame(width: 24, height: 24)
                            .foregroundColor(tintColor)
                            .padding(.all, 10)
                    }
                    .padding(.leading, 7)
                    
                    Spacer()
                }
            }
            
            if let title = title {
                Text(title.string)
                    .font(.system(size: 19, weight: .regular))
                    .foregroundColor(title.tintColor)
            }
            
            if let rightButton = rightButton {
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button {
                        rightButton.touchUpInside()
                    } label: {
                        rightButton.image
                            .foregroundColor(rightButton.tintColor)
                            .frame(width: 24, height: 24)
                            .padding(.all, 10)
                    }
                }
            }
            
            if case let .dismiss(tintColor, onDismiss) = naviType {
                HStack {
                    Spacer()
                    
                    Button {
                        onDismiss()
                    } label: {
                        Image("absence")
                            .frame(width: 24, height: 24)
                            .foregroundColor(tintColor)
                            .padding(.all, 10)
                    }
                    .padding(.leading, 7)
                }
            }
        }
        .frame(height: 44)
    }
}
