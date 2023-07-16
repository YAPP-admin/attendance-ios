//
//  SettingView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI

import ComposableArchitecture

struct SettingView: View {
    
    let store: StoreOf<Setting>
    
    var body: some View {
        VStack {
            YPText(string: "아직 출석 전이에요", color: .gray_600, font: .YPBody1)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                   
                } label: {
                    Image("setting")
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: .init(initialState: Setting.State(), reducer: Setting()))
    }
}
