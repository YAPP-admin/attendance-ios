//
//  ScoreCheckView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI

import ComposableArchitecture

struct ScoreCheckView: View {
    let store: StoreOf<ScoreCheck>
    
    var body: some View {
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        ScrollView(.vertical, showsIndicators: false) {
          
          VStack(spacing: 0) {
            
            ScoreChartView(
              store: self.store.scope(
                state: \.scoreChart,
                action: ScoreCheck.Action.scoreChart
              )
            )
            .padding(.bottom, 28)
            
            ForEachStore(
              self.store.scope(
                state: \.sessionList,
                action: ScoreCheck.Action.sessionList
              )
            ) { store in
              SessionItemView(store: store)
            }
          }
          .padding(.vertical, 28)
        }
        .onAppear {
          viewStore.send(.onAppear)
        }
      }
    }
}

struct ScoreCheckView_Previews: PreviewProvider {
    static var previews: some View {
      ScoreCheckView(store: .init(initialState: ScoreCheck.State(member: nil), reducer: ScoreCheck()))
    }
}

extension SessionStatus {
  var textColor: Color {
    switch self {
    case .attendance, .admit:
      return .etc_green
    case .absent:
      return .etc_red
    case .late:
      return .etc_yellow_font
    case .notNeed, .pre:
      return .gray_400
    }
  }
  
  var image: Image {
    switch self {
    case .attendance:
      return Image("attendance")
    case .absent:
      return Image("absence")
    case .late:
      return Image("tardy")
    case .admit:
      return Image("admit")
    case .notNeed, .pre:
      return Image("")
    }
  }
  
  var title: String {
    switch self {
    case .attendance:
      return "출석"
    case .absent:
      return "결석"
    case .late:
      return "지각"
    case .admit:
      return "출석 인정"
    case .notNeed:
      return "출석 체크 없는 날"
    case .pre:
      return "예정"
    }
  }
}
