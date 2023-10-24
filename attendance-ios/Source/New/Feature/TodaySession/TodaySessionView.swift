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
  
  init(store: StoreOf<TodaySession>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ScrollView {
        VStack(spacing: 20) {
          
          Color.gray_200
            .frame(height: 500)
          
          Image(viewStore.isCompleteAttendance ? "illust_member_home_enabled" : "illust_member_home_disabled")
            .resizable()
            .frame(width: 375, height: 88)
          
          VStack {
            HStack(spacing: 8) {
              Image(viewStore.isCompleteAttendance ? "qr_check_enabled" : "info_check_disabled")
                .resizable()
                .frame(width: 20, height: 20)
              
              YPText(
                string: viewStore.isCompleteAttendance ? "출석을 완료했어요": "아직 출석 전이에요",
                color: viewStore.isCompleteAttendance ? .yapp_orange : .gray_600,
                font: .YPBody1
              )
              .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.all, 20)
          }
          .background(Color.background)
          .cornerRadius(10)
          .padding(.horizontal, 24)
          
          VStack(spacing: 0) {
            VStack(spacing: 0) {
              YPText(
                string: AttributedString(viewStore.sessionDate),
                color: .gray_600,
                font: Font.YPFont(type: .medium, size: 16)
              )
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.top, 24)
              .padding(.bottom, 28)
              
              YPText(
                string: AttributedString(viewStore.sessionTitle),
                color: .gray_1000,
                font: Font.YPHead1
              )
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.bottom, 12)
              
              YPText(
                string: AttributedString(viewStore.sessionDescription),
                color: .gray_800,
                font: Font.YPFont(type: .medium, size: 16)
              )
              .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 24)
            
            Spacer()
          }
          .background(Color.background)
          .cornerRadiusPart(20, corners: [.topLeft, .topRight])
        }
        .padding(.top, -500)
        .background(Color.gray_200)
        .onAppear {
          viewStore.send(.onAppear)
        }
      }
    }
  }
}
