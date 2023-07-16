//
//  SignUpPositionView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI

import ComposableArchitecture

struct SignUpPositionView: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    let store: StoreOf<SignUpPosition>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                
                ZStack {
                    
                    VStack(spacing: 28) {
                        YPText(
                            string: "속한 직군을\n알려주세요",
                            color: .gray_1200,
                            font: .YPHead1
                        )
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            HStack {
                                Button {
                                    viewStore.send(.select(.projectManager))
                                } label: {
                                    YPText(
                                        string: "PM",
                                        color: viewStore.selectedPosition == .projectManager ? .white : .gray_800,
                                        font: .YPSubHead1
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 22)
                                    .background(viewStore.selectedPosition == .projectManager ? Color.yapp_orange : Color.gray_200)
                                    .cornerRadius(61)
                                }
                                
                                Button {
                                    viewStore.send(.select(.designer))
                                } label: {
                                    YPText(
                                        string: "UX/UI Design",
                                        color: viewStore.selectedPosition == .designer ? .white : .gray_800,
                                        font: .YPSubHead1
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 22)
                                    .background(viewStore.selectedPosition == .designer ? Color.yapp_orange : Color.gray_200)
                                    .cornerRadius(61)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Button {
                                    viewStore.send(.select(.android))
                                } label: {
                                    YPText(
                                        string: "Android",
                                        color: viewStore.selectedPosition == .android ? .white : .gray_800,
                                        font: .YPSubHead1
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 22)
                                    .background(viewStore.selectedPosition == .android ? Color.yapp_orange : Color.gray_200)
                                    .cornerRadius(61)
                                }
                                
                                Button {
                                    viewStore.send(.select(.ios))
                                } label: {
                                    YPText(
                                        string: "iOS",
                                        color: viewStore.selectedPosition == .ios ? .white : .gray_800,
                                        font: .YPSubHead1
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 22)
                                    .background(viewStore.selectedPosition == .ios ? Color.yapp_orange : Color.gray_200)
                                    .cornerRadius(61)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            HStack {
                                Button {
                                    viewStore.send(.select(.web))
                                } label: {
                                    YPText(
                                        string: "Web",
                                        color: viewStore.selectedPosition == .web ? .white : .gray_800,
                                        font: .YPSubHead1
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 22)
                                    .background(viewStore.selectedPosition == .web ? Color.yapp_orange : Color.gray_200)
                                    .cornerRadius(61)
                                }
                                
                                Button {
                                    viewStore.send(.select(.server))
                                } label: {
                                    YPText(
                                        string: "Server",
                                        color: viewStore.selectedPosition == .server ? .white : .gray_800,
                                        font: .YPSubHead1
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 22)
                                    .background(viewStore.selectedPosition == .server ? Color.yapp_orange : Color.gray_200)
                                    .cornerRadius(61)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            Spacer()
                            
                            NavigationLink(state: App.Path.State.signUpCode(SignUpCode.State(name: viewStore.name, selectedPosition: viewStore.selectedPosition ?? .projectManager))) {
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

struct SignUpPositionView_Preview: PreviewProvider {
    static var previews: some View {
        SignUpPositionView(store: .init(initialState: SignUpPosition.State(name: "이름이 들어가겠지"), reducer: SignUpPosition()))
    }
}

