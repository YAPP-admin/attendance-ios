//
//  ScoreChartView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/20.
//

import SwiftUI
import Charts

import ComposableArchitecture

struct ScoreChartView: View {
  let store: StoreOf<ScoreChart>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      VStack(spacing: 28) {
        VStack {
          HStack {
            Spacer()
            
            NavigationLink(state: ScoreCoordinator.Path.State.scoreInfo(ScoreInfo.State())) {
              Image("help")
                .frame(width: 44, height: 44)
            }
          }
          .padding(.trailing, 14)
          
          HalfDonutChartView(point: viewStore.score, color: .etc_green)
            .overlay {
              VStack(spacing: 0) {
                YPText(
                  string: AttributedString("지금 내 점수는"),
                  color: .gray_600,
                  font: .YPBody1
                )
                
                YPText(
                  string: AttributedString(String(viewStore.score)),
                  color: .gray_1000,
                  font: Font.YPFont(type: .bold, size: 48)
                )
              }
            }
        }
        .padding(.bottom, -20)
        
        HStack(spacing: 0) {
          
          VStack {
            HStack(spacing: 4) {
              Image("attendance")
                .frame(width: 20, height: 20)
              
              YPText(
                string: AttributedString("출석"),
                color: .gray_600,
                font: .YPBody2
              )
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 40)
            .background(Color.gray_200)
            
            YPText(
              string: AttributedString(String(viewStore.attendanceCount)),
              color: .gray_800,
              font: .YPHead2
            )
            .frame(maxHeight: .infinity, alignment: .center)
          }
          
          VStack {
            HStack(spacing: 4) {
              Image("tardy")
                .frame(width: 20, height: 20)
              
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
              string: AttributedString(String(viewStore.lateCount)),
              color: .gray_800,
              font: .YPHead2
            )
            .frame(maxHeight: .infinity, alignment: .center)
          }
          
          VStack {
            HStack(spacing: 4) {
              Image("absence")
                .frame(width: 20, height: 20)
              
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
              string: AttributedString(String(viewStore.absentCount)),
              color: .gray_800,
              font: .YPHead2
            )
            .frame(maxHeight: .infinity, alignment: .center)
          }
        }
        .frame(height: 100)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .inset(by: -0.75)
            .stroke(Color.gray_200, lineWidth: 1.5)
        )
        .padding(.horizontal, 24)
        
        Color.gray_200
          .frame(maxWidth: .infinity, alignment: .center)
          .frame(height: 12)
      }
    }
  }
}

public extension View {
    func debug(_ color: Color = .blue) -> some View {
        modifier(FrameInfo(color: color))
    }
}

private struct FrameInfo: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
        #if DEBUG
            .overlay(GeometryReader(content: overlay))
        #endif
    }
    
    func overlay(for geometry: GeometryProxy) -> some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .strokeBorder(style: .init(lineWidth: 1, dash: [3]))
                .foregroundColor(color)
            
            Text("(\(Int(geometry.frame(in: .global).origin.x)), \(Int(geometry.frame(in: .global).origin.y))) \(Int(geometry.size.width))x\(Int(geometry.size.height))")
                .font(.caption2)
                .minimumScaleFactor(0.5)
                .foregroundColor(color)
                .padding(3)
                .offset(y: -20)
        }
    }
}

