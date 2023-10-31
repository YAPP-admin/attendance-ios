//
//  OnboardingView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import SwiftUI

import AuthenticationServices

import ComposableArchitecture

struct OnboardingView: View {
  
  let store: StoreOf<Onboarding>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        if viewStore.isFirstLaunched {
          LottieView(filename: "splash_main") { _ in
            viewStore.send(.launch)
          }
        } else {
          VStack {
            Image("splash_main_still")
              .frame(width: 375, height: 375)
              .padding(.top, 120)
            
            Spacer()
          }
        }
        
        if viewStore.isLaunching || viewStore.isFirstLaunched == false {
          
          VStack(spacing: 8) {
            Spacer()
            
            YPText(
              string: "3초만에 끝나는 \n간편한 출석체크",
              color: .gray_1200,
              font: .YPHead1
            )
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 68)
            
            SignInWithAppleButton(
              onRequest: { request in
                request.requestedScopes = [.fullName]
              },
              onCompletion: { result in
                switch result {
                case .success(let authResults):
                  switch authResults.credential{
                  case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let userId = appleIDCredential.user
                    let fullName = appleIDCredential.fullName
                    let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                    
                    print(userId)
                    print(name)
                    viewStore.send(.appleSignButtonTapped(name: name))
                  default:
                    break
                  }
                case .failure(let error):
                  print(error.localizedDescription)
                  print("error")
                }
              }
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 44)
            .cornerRadius(12)
            
            Button {
              viewStore.send(.kakaoSignButtonTapped)
            } label: {
              HStack(spacing: 6) {
                Image("kakao_login")
                
                YPText(
                  string: "카카오 로그인",
                  color: .gray_1200,
                  font: .YPFont(type: .semiBold, size: 19)
                )
              }
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(.vertical, 10)
              .background(Color.etc_yellow)
              .cornerRadius(12)
            }
            
            if viewStore.isShowGuestButton {
              Button {
                viewStore.send(.guestSignButtonTapped)
              } label: {
                HStack(spacing: 6) {
                  
                  YPText(
                    string: "guest sign",
                    color: .white,
                    font: .YPFont(type: .regular, size: 19)
                  )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 10)
                .background(Color.gray_1200)
                .cornerRadius(12)
              }
            }
          }
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.horizontal, 24)
          .padding(.bottom, 47)
        }
      }
      .background(viewStore.isLaunching || viewStore.isFirstLaunched == false ? Color.white : Color.yapp_orange)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(
      store: .init(
        initialState: Onboarding.State(),
        reducer: Onboarding()
      )
    )
  }
}
