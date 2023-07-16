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
    
    @State private var text: String = ""
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                
                ZStack {
                    
                    VStack(spacing: 28) {
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
                        
                        HStack(spacing: 13) {
                            
                            Button {
                                
                            } label: {
                                Rectangle()
                                .frame(width: 72, height: 72)
                                .foregroundColor(Color.gray_200)
                                .cornerRadius(50)
                            }
                            
                            Button {
                            } label: {
                                Rectangle()
                                .frame(width: 72, height: 72)
                                .foregroundColor(Color.gray_200)
                                .cornerRadius(50)
                            }
                            
                            Button {
                                
                            } label: {
                                Rectangle()
                                .frame(width: 72, height: 72)
                                .foregroundColor(Color.gray_200)
                                .cornerRadius(50)
                            }
                            
                            Button {
                                
                            } label: {
                                Rectangle()
                                .frame(width: 72, height: 72)
                                .foregroundColor(Color.gray_200)
                                .cornerRadius(50)
                            }
                        }
                        
                        VStack {
                            Spacer()
                            
                            NavigationLink(state: App.Path.State.homeTab(HomeTab.State(selectedTab: .todaySession))) {
                                YPText(
                                    string: "다음",
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
                    .padding(.horizontal, 24)
                    .padding(.bottom, 6)
                }
                .padding(.top, 32)
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
