//
//  TodaySessionView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/12.
//

import SwiftUI

import ComposableArchitecture

struct TodaySessionView: View {
    
    let store: StoreOf<TodaySession>
    
    var body: some View {
        VStack {
            YPText(string: "아직 출석 전이에요", color: .gray_600, font: .YPBody1)
        }
    }
}

struct TodaySessionView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySessionView(store: .init(initialState: TodaySession.State(), reducer: TodaySession()))
    }
}
