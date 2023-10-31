//
//  SessionInfoView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/27.
//

import SwiftUI

import ComposableArchitecture

struct SessionInfoView: View {
    let store: StoreOf<SessionInfo>
    
    var body: some View {
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        VStack {
          VStack(spacing: 0) {
            
            HStack(spacing: 0) {
              if viewStore.status != .pre && viewStore.status != .notNeed {
                viewStore.status.image
                  .frame(width: 20, height: 20)
                  .padding(.top, 2)
              }
              
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
            .padding(.bottom, 28)
            
            YPText(
              string: AttributedString(viewStore.session.title),
              color: .gray_1000,
              font: Font.YPFont(type: .bold, size: 24)
            )
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            YPText(
              string: AttributedString(viewStore.session.description),
              color: .gray_800,
              font: Font.YPFont(type: .medium, size: 16)
            )
            .lineSpacing(3)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
          }
          .padding(.vertical, 40)
          .padding(.horizontal, 24)
          
          Spacer()
        }
        .navigationTitle(viewStore.session.title)
      }
    }
}
