//
//  HomeTabBarView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI
import PopupView

import ComposableArchitecture

struct HomeTabView: View {
  
  let store: StoreOf<HomeTab>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack(alignment: .bottom) {
        
        TabView(selection: viewStore.binding(\.$selectedTab)) {
          TodaySessionView(
            store: self.store.scope(
              state: \.todaySession,
              action: HomeTab.Action.todaySession
            )
          )
          .tabItem({
            VStack(spacing: 4) {
              Image("home_disabled")
              
              Text("오늘 세션")
            }
            .frame(width: 100)
          })
          .tag(HomeTab.Tab.todaySession)
          
          ScoreCheckView(
            store: self.store.scope(
              state: \.scoreCheck,
              action: HomeTab.Action.scoreCheck
            )
          )
          .tabItem({
            VStack(spacing: 4) {
              Image("check_disabled")
              
              Text("출결 확인")
            }
            .frame(width: 100)
          })
          .tag(HomeTab.Tab.scoreCheck)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .applyIf(viewStore.selectedTab == .todaySession, apply: {
          $0
            .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                  viewStore.send(.tappedSettingButton(viewStore.member))
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
            .navigationTitle("")
            .font(Font.YPFont(type: .medium, size: 18))
            .foregroundColor(Color.gray_1200)
        })
        .applyIf(viewStore.selectedTab == .scoreCheck, apply: {
          $0
            .navigationTitle("출결 점수 확인")
        })
        
        Button {
          viewStore.send(.tappedAttendanceButton)
        } label: {
          
          VStack {
            Image("qr_home")
              .frame(width: 45, height: 45)
              .background(Color.yapp_orange)
              .clipShape(Circle())
          }
        }
      }
      .fullScreenCover(
        store: self.store.scope(state: \.$destination, action: { .destination($0) }),
        state: /HomeTab.Destination.State.attendanceCode,
        action: HomeTab.Destination.Action.attendanceCode
      ) { store in
        AttendanceCodeView(store: store)
      }
      .popup(isPresented: viewStore.$isShowToast) {
        VStack {
          YPText(
            string: AttributedString(viewStore.toastMessage),
            color: .white,
            font: .YPBody1
          )
          .padding(.vertical, 12)
          .frame(maxWidth: .infinity, alignment: .center)

        }
        .background(Color(red: 0.173, green: 0.185, blue: 0.208, opacity: 0.8))
        .cornerRadius(10)
        .padding(.horizontal, 24)
        .padding(.bottom, 50)
        
      } customize: {
          $0
              .type(.floater())
              .position(.bottom)
              .animation(.spring())
              .closeOnTapOutside(true)
              .autohideIn(2)
      }
      
    }
  }
}

struct HomeTabView_Previews: PreviewProvider {
  static var previews: some View {
    HomeTabView(store: .init(initialState: HomeTab.State(member: nil, selectTab: .todaySession), reducer: HomeTab()))
  }
}
