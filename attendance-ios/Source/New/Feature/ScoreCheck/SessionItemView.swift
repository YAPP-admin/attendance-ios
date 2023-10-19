//
//  SessionItemView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/20.
//

import SwiftUI

import ComposableArchitecture

/// 코드 더럽다..ㅎㅎ
struct SessionItemView: View {
  
  let store: StoreOf<SessionItem>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .top, spacing: 8) {
        
        viewStore.status.image
          .frame(width: 20, height: 20)
          .padding(.top, 2)
        
        VStack(spacing: 4) {
          
          HStack(spacing: 0) {
            YPText(
              string: AttributedString(viewStore.status.title),
              color: viewStore.status.textColor,
              font: Font.YPFont(type: .medium, size: 14)
            )
            
            Spacer()
            
            YPText(
              string: AttributedString(viewStore.sessionDate),
              color: .gray_400,
              font: Font.YPFont(type: .medium, size: 14)
            )
          }
          
          if viewStore.session.type == .dayOff
            || viewStore.status == .pre
            || (
              viewStore.status == .notNeed &&
              Date().isPast(than: viewStore.session.date.date()) == false
            )
          {
            YPText(
              string: AttributedString(viewStore.session.title),
              color: .gray_600,
              font: Font.YPFont(type: .bold, size: 18)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            YPText(
              string: AttributedString(viewStore.session.description),
              color: .gray_600,
              font: Font.YPFont(type: .medium, size: 16)
            )
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
          } else {
            YPText(
              string: AttributedString(viewStore.session.title),
              color: .gray_1200,
              font: Font.YPFont(type: .bold, size: 18)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            YPText(
              string: AttributedString(viewStore.session.description),
              color: .gray_800,
              font: Font.YPFont(type: .medium, size: 16)
            )
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
          }
          
          
        }
      }
      .padding(.all, 24)
      
    }
  }
}
