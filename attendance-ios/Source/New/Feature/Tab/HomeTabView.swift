//
//  HomeTabBarView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI

import ComposableArchitecture

struct HomeTabView: View {
    
    let store: StoreOf<HomeTab>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(\.$selectedTab)) {
                TodaySessionView(store: self.store.scope(state: \.todaySession, action: HomeTab.Action.todaySession))
                    .tabItem({
                        VStack(spacing: 4) {
                            Image("home_disabled")
                            
                            Text("오늘 세션")
                        }
                        
                    })
                    .tag(HomeTab.Tab.todaySession)
                
                ScoreCheckView(store: self.store.scope(state: \.scoreCheck, action: HomeTab.Action.scoreCheck))
                    .tabItem({
                        VStack(spacing: 4) {
                            Image("check_disabled")
                            
                            Text("오늘 세션")
                        }
                    })
                    .tag(HomeTab.Tab.scoreCheck)
            }
            .navigationBarBackButtonHidden(true)
            .applyIf(viewStore.selectedTab == .todaySession, apply: {
                $0
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                               
                            } label: {
                                Image("setting")
                                    .foregroundColor(Color.gray_600)
                            }
                        }
                    }
                    .toolbarBackground(
                        Color.gray_200,
                        for: .navigationBar
                    )
                    .toolbarBackground(.visible, for: .navigationBar)
            })
            .applyIf(viewStore.selectedTab == .scoreCheck, apply: {
                $0
                    .navigationTitle("출결 점수 확인")
            })
            .applyIf(viewStore.selectedTab != .scoreCheck, apply: {
                $0
                    .navigationTitle("")
                    .font(Font.YPFont(type: .medium, size: 18))
                    .foregroundColor(Color.gray_1200)
            })
            
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(store: .init(initialState: HomeTab.State(selectedTab: .todaySession), reducer: HomeTab()))
    }
}
