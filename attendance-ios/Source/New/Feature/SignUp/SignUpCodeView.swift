//
//  SignUpCodeView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI

import ComposableArchitecture

struct SignUpCodeView: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    let store: StoreOf<SignUpCode>
    
    @FocusState private var isFocus: Bool
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                
                ZStack {
                    
                    VStack(spacing: 28) {
                        VStack(spacing: 20) {
                            ZStack {
                                TextField("", text: viewStore.binding(\.$code))
                                    .focused($isFocus)
                                    .keyboardType(.decimalPad)
                                    .modifier(KeyboardAdaptive())
                                    .foregroundColor(Color.clear)
                                    .accentColor(Color.clear)
                                    .background(Color.clear)
                                    .onChange(of: isFocus, perform: { newValue in
                                        viewStore.send(.focus(newValue), animation: .default)
                                    })
                                    .onChange(of: viewStore.isFocus, perform: { value in
                                        isFocus = value
                                    })
                                
                                VStack(spacing: 12) {
                                    YPText(
                                        string: "너, 내 동료가 돼라!",
                                        color: .gray_1200,
                                        font: .YPHead1
                                    )
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    YPText(
                                        string: "암호 코드 4자리를 입력해주세요",
                                        color: .gray_800,
                                        font: .YPBody1
                                    )
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color.background)
                            }
                            .onAppear {
                                isFocus = true
                            }
                            
                            HStack(spacing: 13) {
                                
                                Button {
                                    isFocus = true
                                } label: {
                                    if viewStore.firstInputView {
                                        Image("code_first")
                                            .resizable()
                                            .frame(width: 72, height: 72)
                                    } else {
                                        Rectangle()
                                        .frame(width: 72, height: 72)
                                        .foregroundColor(Color.gray_200)
                                        .cornerRadius(50)
                                    }
                                }
                                
                                Button {
                                    isFocus = true
                                } label: {
                                    if viewStore.secondInputView {
                                        Image("code_second")
                                            .resizable()
                                            .frame(width: 72, height: 72)
                                    } else {
                                        Rectangle()
                                        .frame(width: 72, height: 72)
                                        .foregroundColor(Color.gray_200)
                                        .cornerRadius(50)
                                    }
                                }
                                
                                Button {
                                    isFocus = true
                                } label: {
                                    if viewStore.thirdInputView {
                                        Image("code_third")
                                            .resizable()
                                            .frame(width: 72, height: 72)
                                    } else {
                                        Rectangle()
                                        .frame(width: 72, height: 72)
                                        .foregroundColor(Color.gray_200)
                                        .cornerRadius(50)
                                    }
                                }
                                
                                Button {
                                    isFocus = true
                                } label: {
                                    if viewStore.fourthInputView {
                                        Image("code_fourth")
                                            .resizable()
                                            .frame(width: 72, height: 72)
                                    } else {
                                        Rectangle()
                                        .frame(width: 72, height: 72)
                                        .foregroundColor(Color.gray_200)
                                        .cornerRadius(50)
                                    }
                                }
                            }
                            .padding(.top, 4)
                            
                            if viewStore.isIncorrectCode && viewStore.isConfirmCode {
                                YPText(
                                    string: "틀린 코드입니다",
                                    color: .yapp_orange,
                                    font: .YPSubHead1
                                )
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                        }
                        .padding(.top, 32)
                        .padding(.horizontal, 24)
                        
                        
                        VStack {
                            Spacer()
                            
                            if viewStore.isIncorrectCode == false && viewStore.isConfirmCode == false {
                                Button {
                                    viewStore.send(.codeCheck)
                                } label: {
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
                                .padding(.horizontal, viewStore.isFocus ? 0 : 24)
                                .padding(.bottom, viewStore.isFocus ? 0 : 6)
                            }
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                    }
                }
            }
        }
    }
}
