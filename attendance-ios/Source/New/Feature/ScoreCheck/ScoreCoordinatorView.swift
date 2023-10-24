//
//  ScoreFeatureView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/22.
//

//import SwiftUI
//
//import ComposableArchitecture
//
//struct ScoreCoordinatorView: View {
//    
//    let store: StoreOf<ScoreCoordinator>
//    
//    var body: some View {
//      WithViewStore(self.store, observe:  { $0 }) { viewStore in
//        
//        NavigationStackStore(
//          self.store.scope(
//            state: \.path,
//            action: { .path($0) })
//        ) {
//          ScoreCheckView(store: self.store.scope(state: \.scoreCheck, action: ScoreCoordinator.Action.scoreCheck))
//            .toolbar(.visible, for: .navigationBar)
//            .navigationTitle("출결 확인")
//        } destination: {
//          switch $0 {

//          }
//        }
//        .tint(Color.gray_800)
//      }
//        
//    }
//}
