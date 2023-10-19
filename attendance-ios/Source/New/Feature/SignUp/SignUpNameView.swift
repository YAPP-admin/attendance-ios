//
//  LoginView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import SwiftUI

import PopupView
import ComposableArchitecture

struct SignUpNameView: View {
    
    @FocusState private var isFocus: Bool
    
    let store: StoreOf<SignUpName>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                
                ZStack {
                    
                    VStack(spacing: 28) {
                        VStack(spacing: 12) {
                            YPText(
                                string: "이름을 작성해주세요",
                                color: .gray_1200,
                                font: .YPHead1
                            )
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            YPText(
                                string: "실명을 작성해야 출석을 확인할 수 있어요",
                                color: .gray_800,
                                font: .YPBody1
                            )
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.top, 32)
                        
                        VStack {
                            TextField(text: viewStore.binding(\.$textName), label: {
                                Text("ex. 야뿌")
                                    .foregroundColor(.gray_400)
                                    .font(.YPSubHead1)
                            })
                            .foregroundColor(Color.gray_800)
                            .font(.YPSubHead1)
                            .focused($isFocus)
                            .padding(.all, 20)
                        }
                        .background(Color.gray_200)
                        .cornerRadius(50)
                        
                        Spacer()
                    }
                    .modifier(KeyboardAdaptive())
                    .onChange(of: isFocus, perform: { newValue in
                        viewStore.send(.focus(newValue), animation: .default)
                    })
                    .onChange(of: viewStore.isFocus, perform: { value in
                        isFocus = value
                    })
                    .onAppear {
                        isFocus = true
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 24)
                    
                    VStack {
                        Spacer()
                        
                        NavigationLink(state: App.Path.State.signUpPosition(SignUpPosition.State(name: viewStore.textName))) {
                            YPText(
                                string: "다음",
                                color: .white,
                                font: .YPHead2
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 19)
                            .background(viewStore.isEnabledNextButton ? Color.yapp_orange : Color.gray_400)
                            .disabled(viewStore.isEnabledNextButton == false)
                            .cornerRadius(viewStore.isFocus ? 0 : 12)
                        }
                    }
                    .padding(.horizontal, viewStore.isFocus ? 0 : 24)
                    .padding(.bottom, viewStore.isFocus ? 0 : 6)
                }
            }
            .popup(isPresented: viewStore.binding(\.$showingCancelPopup)) {
                VStack {
                    VStack(spacing: 19) {
                        VStack(spacing: 8) {
                            YPText(
                                string: "입력을 취소할까요?",
                                color: .gray_1200,
                                font: .YPHead2
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            YPText(
                                string: "입력한 내용은 저장되지 않아요",
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
                                    string: "취소하기",
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
                                    string: "아니요",
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
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNameView(store: .init(initialState: SignUpName.State(userName: "이호영"), reducer: SignUpName()))
    }
}
