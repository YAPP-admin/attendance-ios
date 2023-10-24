//
//  TeamSelectView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/23.
//

import SwiftUI

import ComposableArchitecture

struct TeamSelectView: View {
    
    let store: StoreOf<TeamSelect>
    
    var body: some View {
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        VStack {
          HStack {
            
            Spacer()
            
            Button {
              viewStore.send(.dismiss)
            } label: {
              Image("close")
                .resizable()
                .tint(.gray_800)
                .frame(width: 24, height: 24)
                .padding(.trailing, 17)
            }
            
          }
          .frame(maxWidth: .infinity)
          .frame(height: 56)
          
          VStack(spacing: 28) {
            YPText(
              string: "소속 팀을\n알려주세요",
              color: .gray_1200,
              font: .YPHead1
            )
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
              
              VStack(spacing: 12) {
                
                HStack(spacing: 15) {
                  Button {
                    viewStore.send(.selectTeamType(.android))
                  } label: {
                    YPText(
                      string: AttributedString(TeamType.android.lowerCase),
                      color: viewStore.selectedTeamType == .android ? .white : .gray_800,
                      font: .YPSubHead1
                    )
                    .padding(.vertical, 14)
                    .padding(.horizontal, 22)
                    .background(viewStore.selectedTeamType == .android ? Color.yapp_orange : Color.gray_200)
                    .cornerRadius(61)
                  }
                  
                  Button {
                    viewStore.send(.selectTeamType(.ios))
                  } label: {
                    YPText(
                      string: AttributedString(TeamType.ios.lowerCase),
                      color: viewStore.selectedTeamType == .ios ? .white : .gray_800,
                      font: .YPSubHead1
                    )
                    .padding(.vertical, 14)
                    .padding(.horizontal, 22)
                    .background(viewStore.selectedTeamType == .ios ? Color.yapp_orange : Color.gray_200)
                    .cornerRadius(61)
                  }
                  
                  Spacer()
                }
                
                Button {
                  viewStore.send(.selectTeamType(.web))
                } label: {
                  YPText(
                    string: AttributedString(TeamType.web.lowerCase),
                    color: viewStore.selectedTeamType == .web ? .white : .gray_800,
                    font: .YPSubHead1
                  )
                  .padding(.vertical, 14)
                  .padding(.horizontal, 22)
                  .background(viewStore.selectedTeamType == .web ? Color.yapp_orange : Color.gray_200)
                  .cornerRadius(61)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
              
              if let _ = viewStore.selectedTeamType {
                
                VStack(spacing: 10) {
                  
                  YPText(
                    string: "하나만 더 알려주세요",
                    color: .gray_1200,
                    font: .YPHead1
                  )
                  .frame(maxWidth: .infinity, alignment: .leading)
                  
                  HStack(spacing: 15) {
                    Button {
                      viewStore.send(.selectTeamNumber(1))
                    } label: {
                      YPText(
                        string: AttributedString("1팀"),
                        color: viewStore.selectedTeamNumber == 1 ? .white : .gray_800,
                        font: .YPSubHead1
                      )
                      .padding(.vertical, 14)
                      .padding(.horizontal, 22)
                      .background(viewStore.selectedTeamNumber == 1 ? Color.yapp_orange : Color.gray_200)
                      .cornerRadius(61)
                    }
                    
                    Button {
                      viewStore.send(.selectTeamNumber(2))
                    } label: {
                      YPText(
                        string: AttributedString("2팀"),
                        color: viewStore.selectedTeamNumber == 2 ? .white : .gray_800,
                        font: .YPSubHead1
                      )
                      .padding(.vertical, 14)
                      .padding(.horizontal, 22)
                      .background(viewStore.selectedTeamNumber == 2 ? Color.yapp_orange : Color.gray_200)
                      .cornerRadius(61)
                    }
                    
                    Spacer()
                  }
                }
                .padding(.top, 52)
                
              }
              
              Spacer()
              
              VStack {
                
                YPText(
                  string: "팀 선택을 완료하면 수정할 수 없어요.\n 다시 한 번 확인해 주세요!",
                  color: .white,
                  font: .YPBody2
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                  
                  viewStore.send(.tappedConfirmButton)
                } label: {
                  YPText(
                    string: "확인",
                    color: .white,
                    font: .YPHead2
                  )
                  .frame(maxWidth: .infinity, alignment: .center)
                  .padding(.vertical, 19)
                  .background(viewStore.isEnabledNextButton ? Color.yapp_orange : Color.gray_400)
                  .disabled(viewStore.isEnabledNextButton == false)
                  .cornerRadius(12)
                }
              }
            }
          }
          .padding(.top, 32)
          .padding(.horizontal, 24)
          .padding(.bottom, 24)
          .onAppear {
            viewStore.send(.onAppear)
          }
        }
        
      }
    }
}
