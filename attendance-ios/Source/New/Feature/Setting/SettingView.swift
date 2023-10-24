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
                viewStore.send(.logout)
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
                viewStore.send(.deleteUser)
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
      .popup(isPresented: viewStore.binding(\.$showingCancelPopup)) {
          VStack {
              VStack(spacing: 19) {
                  VStack(spacing: 8) {
                      YPText(
                          string: "정말 탈퇴하시겠어요?",
                          color: .gray_1200,
                          font: .YPHead2
                      )
                      .frame(maxWidth: .infinity, alignment: .leading)
                      
                      YPText(
                          string: "탈퇴하면 모든 정보가 사라져요.",
                          color: .gray_800,
                          font: .YPBody1
                      )
                      .frame(maxWidth: .infinity, alignment: .leading)
                  }
                  
                  HStack(spacing: 8) {
                      Button {
                          viewStore.send(.pop)
                      } label: {
                          YPText(
                              string: "취소",
                              color: .gray_800,
                              font: .YPSubHead1
                          )
                          .padding(.vertical, 12)
                          .frame(maxWidth: .infinity)
                      }
                      .background(Color.gray_200)
                      .cornerRadius(10)
                      .frame(maxWidth: .infinity)

                      Button {
                          viewStore.send(.dismissCancelPopup)
                      } label: {
                          YPText(
                              string: "탈퇴합니다",
                              color: .white,
                              font: .YPSubHead1
                          )
                          .padding(.vertical, 12)
                          .frame(maxWidth: .infinity)
                      }
                      .background(Color.yapp_orange)
                      .cornerRadius(10)
                  }
                  
              }
              .padding(.all, 24)
          }
          .background(Color.white)
          .cornerRadius(10)
          .padding(.horizontal, 32)
      } customize: {
          $0
           .backgroundColor(.black.opacity(0.4))
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}
