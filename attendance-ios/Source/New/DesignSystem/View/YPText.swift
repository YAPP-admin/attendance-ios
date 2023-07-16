//
//  Text.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import SwiftUI

struct YPText: View {
    
    private var string: AttributedString
    private var color: Color
    private var font: Font
    
    public init(string: AttributedString, color: Color, font: Font) {
        self.string = string
        self.color = color
        self.font = font
    }
    
    var body: some View {
        Text(string)
            .foregroundColor(color)
            .font(font)
    }
}

struct Text_Previews: PreviewProvider {
    static var previews: some View {
        YPText(string: "얍얍얍", color: .etc_yellow, font: .YPBody2)
    }
}
