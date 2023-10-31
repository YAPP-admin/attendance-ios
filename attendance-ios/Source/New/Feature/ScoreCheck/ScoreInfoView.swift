//
//  ScoreInfoView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/22.
//

import SwiftUI

import ComposableArchitecture

struct ScoreInfoView: View {
    let store: StoreOf<ScoreInfo>
    
    var body: some View {
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        VStack {
          VStack(spacing: 28) {
            VStack(spacing: 10) {
              YPText(
                string: AttributedString("YAPP의 구성원은\n모든 세션에 필수적으로 참여해야 해요!"),
                color: .gray_1000,
                font: .YPHead2
              )
              .lineSpacing(7)
              .frame(maxWidth: .infinity, alignment: .leading)
              
              YPText(
                string: AttributedString("전체 세션만 출석 체크를 진행해요."),
                color: .gray_600,
                font: .YPBody1
              )
              .frame(maxWidth: .infinity, alignment: .leading)
              
            }
            
            HStack(spacing: 0) {
              
              VStack {
                HStack(spacing: 0) {
                  
                  YPText(
                    string: AttributedString("지각"),
                    color: .gray_600,
                    font: .YPBody2
                  )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 40)
                .background(Color.gray_200)
                
                YPText(
                  string: AttributedString("-10점"),
                  color: .gray_800,
                  font: .YPHead2
                )
                .frame(maxHeight: .infinity, alignment: .center)
              }
              
              VStack {
                HStack(spacing: 4) {
                  
                  YPText(
                    string: AttributedString("결석"),
                    color: .gray_600,
                    font: .YPBody2
                  )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 40)
                .background(Color.gray_200)
                
                YPText(
                  string: AttributedString("-20점"),
                  color: .gray_800,
                  font: .YPHead2
                )
                .frame(maxHeight: .infinity, alignment: .center)
              }
            }
            .frame(height: 120)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .inset(by: -0.75)
                .stroke(Color.gray_200, lineWidth: 1.5)
            )
            
            YPText(
              string: AttributedString("* 운영진에게 요청 시 결석 1회는 출석으로 인정돼요."),
              color: .gray_600,
              font: .YPBody1
            )
            
          }
          .padding(.horizontal, 24)
          .padding(.top, 24)
          
          Spacer()
          
          VStack {
            VStack(spacing: 12) {
              YPText(
                string: AttributedString("읽어보세요!"),
                color: .gray_600,
                font: .YPFont(type: .bold, size: 14)
              )
              .frame(maxWidth: .infinity, alignment: .leading)
              
              VStack(spacing: 5) {
                HStack(spacing: 0) {
                  YPText(
                    string: AttributedString("﹒"),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  YPText(
                    string: AttributedString("출결 점수는 100점에서 시작해요."),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(alignment: .top, spacing: 0) {
                  YPText(
                    string: AttributedString("﹒"),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  YPText(
                    string: AttributedString("점수가 70점 미만이 되는 회원은 운영진의 심의 하에 제명될 수 있으니 출결에 유의해주세요."),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  .multilineTextAlignment(.leading)
                  .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(spacing: 0) {
                  YPText(
                    string: AttributedString("﹒"),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  YPText(
                    string: AttributedString("회비 납부 무단 연체 시 연체 1일마다 5점이 감점돼요."),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  .multilineTextAlignment(.leading)
                  .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(spacing: 0) {
                  YPText(
                    string: AttributedString("﹒"),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  YPText(
                    string: AttributedString("아르바이트, 인턴, 직장인 우대사항은 없어요."),
                    color: .gray_600,
                    font: .YPCaption1
                  )
                  .multilineTextAlignment(.leading)
                  .frame(maxWidth: .infinity, alignment: .leading)
                }
              }
              
              Spacer()
            }
            .background(Color.gray_200)
            .padding(.vertical, 40)
            .padding(.horizontal, 24)
            
          }
          .frame(height: 300)
          .background(Color.gray_200.edgesIgnoringSafeArea([.bottom]))
          
        }
        .navigationTitle("도움말")
      }
    }
}
