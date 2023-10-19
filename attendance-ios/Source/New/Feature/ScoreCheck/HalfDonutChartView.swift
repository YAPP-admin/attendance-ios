//
//  HalfDonutChartView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/20.
//

import SwiftUI

struct HalfDonutChartView: View {
  
  @State var progress: Double = 0.0
  @State var point: Int = 0
  @State var color: Color = .green
  
  var body: some View {
    ZStack {
      Circle()
        .trim(from: 0.0, to: 0.5)
        .stroke(Color.gray_200, style: StrokeStyle(lineWidth: 12, lineCap: .round))
        .frame(width: 230, height: 230)
        .rotationEffect(.degrees(180))
      
      Circle()
        .trim(from: 0.0, to: progress)
        .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
        .frame(width: 230, height: 230)
        .rotationEffect(.degrees(180))
      
    }
    .frame(width: 250, height: 120)
    .padding(.top, 60)
    .onAppear {
      let score = Double(point) * 0.005
      
      if point >= 80 {
        color = .etc_green
      } else if point >= 70 {
        color = .etc_yellow
      } else {
        color = .etc_red
      }
      
      withAnimation {
        progress = score
      }
    }
  }
}

struct HalfDonutChartView_Previews: PreviewProvider {
  static var previews: some View {
    HalfDonutChartView()
  }
}
