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
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ScrollView {
        VStack(spacing: 28) {
          
          VStack {
            YPText(
              string: AttributedString("YAPP \(viewStore.yappGeneration)기 회원"),
              color: .yapp_orange,
              font: .YPBody1
            )
            .frame(maxWidth: .infinity, alignment: .center)
          }
          .frame(height: 60)
          .background(Color.yapp_orange.opacity(0.1))
          
          VStack(spacing: 16) {
            Image("illust_profile")
              .frame(width: 327, height: 113)
            
            VStack(spacing: 5) {
              YPText(
                string: AttributedString("\(String(describing: viewStore.member?.name ?? "")) 님"),
                color: .gray_800,
                font: .YPBody1
              )
              
              if let team = viewStore.selectTeam {
                YPText(
                  string: AttributedString(
                    "\(viewStore.member?.position.shortValue ?? "") ﹒ \(team.displayName())"),
                  color: .gray_600,
                  font: .YPBody2
                )
              } else {
                YPText(
                  string: AttributedString("\(String(describing: viewStore.member?.position.shortValue ?? ""))"),
                  color: .gray_600,
                  font: .YPBody2
                )
              }
            }
            .padding(.top, 10)
          }
          .padding(.horizontal, 24)
          
          if viewStore.selectTeam == nil {
            Button {
              viewStore.send(.tappedTeamSelect)
            } label: {
              VStack {
                YPText(
                  string: AttributedString("팀 선택하기"),
                  color: .white,
                  font: .YPBody2
                )
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
              }
              .background(Color.yapp_orange)
              .cornerRadius(8)
            }
          }
          
          Color.gray_200
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 12)
          
          VStack(spacing: 32) {
            VStack(spacing: 0) {
              HStack {
                YPText(
                  string: AttributedString("버전 정보"),
                  color: .gray_1200,
                  font: .YPBody1
                )
                
                Spacer()
                
                YPText(
                  string: AttributedString(viewStore.appVersion),
                  color: .gray_600,
                  font: .YPBody1
                )
              }
              .padding(.vertical, 18)
              .padding(.horizontal, 24)
              
              Button {
                
              } label: {
                HStack {
                  YPText(
                    string: AttributedString("개인정보 처리방침"),
                    color: .gray_1200,
                    font: .YPBody1
                  )
                  
                  Spacer()
                  
                  Image("cheron_right")
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 24)
              }
            }
            
            VStack(spacing: 0) {
              Button {

              } label: {
                HStack {
                  YPText(
                    string: AttributedString("로그아웃"),
                    color: .gray_400,
                    font: .YPBody1
                  )
                  
                  Spacer()
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 24)
              }

              Button {

              } label: {
                HStack {
                  YPText(
                    string: AttributedString("회원탈퇴"),
                    color: .gray_400,
                    font: .YPBody1
                  )
                  
                  Spacer()
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 24)
              }
            }
          }
          .navigationTitle("설정")
        }
      }
      .fullScreenCover(
        store: self.store.scope(state: \.$destination, action: { .destination($0) }),
        state: /Setting.Destination.State.teamSelect,
        action: Setting.Destination.Action.teamSelect
      ) { store in
        TeamSelectView(store: store)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}
