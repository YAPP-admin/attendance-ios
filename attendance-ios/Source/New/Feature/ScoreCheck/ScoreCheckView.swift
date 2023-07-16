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
        VStack {
            YPText(string: "출결확인 페이지", color: .gray_600, font: .YPBody1)
        }
    }
}

struct ScoreCheckView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCheckView(store: .init(initialState: ScoreCheck.State(), reducer: ScoreCheck()))
    }
}
