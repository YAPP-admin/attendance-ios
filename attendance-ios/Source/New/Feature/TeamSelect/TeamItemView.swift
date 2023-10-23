//
//  TeamItemView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/23.
//

import SwiftUI

import ComposableArchitecture

struct TeamItemView: View {
  
  let store: StoreOf<TeamItem>
  
  init(store: StoreOf<TeamItem>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Button {
        viewStore.send(.tapped)
      } label: {
        YPText(
          string: AttributedString(viewStore.team.type.lowerCase),
          color: viewStore.isSelected ? .white : .gray_800,
          font: .YPSubHead1
        )
        .padding(.vertical, 14)
        .padding(.horizontal, 22)
        .background(viewStore.isSelected ? Color.yapp_orange : Color.gray_200)
        .cornerRadius(61)
      }
      
    }
  }
}
