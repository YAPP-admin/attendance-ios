//
//  Attendance.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/24.
//

import Foundation

import ComposableArchitecture

struct AttendanceCode: ReducerProtocol {
  
  struct State: Equatable {
    @BindingState var code: String = ""
    var isEnabledNextButton: Bool = false
    var isFocus: Bool = false
    
    var firstInputView: Bool = false
    var secondInputView: Bool = false
    var thirdInputView: Bool = false
    var fourthInputView: Bool = false
    
    var isIncorrectCode: Bool = false
    var isConfirmCode: Bool = false
    
    var session: Session
    var member: Member?
    
    var sessionDate: String {
      let dateFormatter = DateFormatter()
      let sessionDateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let date = dateFormatter.date(from: session.date)
      sessionDateFormatter.dateFormat = "MM월 dd일"
      return sessionDateFormatter.string(from: date ?? Date())
    }
    
    init(
      session: Session,
      member: Member?
    ) {
      self.session = session
      self.member = member
    }
  }
  
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case focus(Bool)
    case codeCheck
    case incorrectCode
    
    case setAttendance(Status)
    case completeAttendance(Member)
    case sendError
    
    case dismissScene
  }
  
  @Dependency(\.kakaoSign) var kakaoSign
  @Dependency(\.memberInfo.memberInfo) var memberInfo
  
  var body: some ReducerProtocolOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.$code):
        let count = state.code.count
        let maxInputViews = 4
        var inputViews = Array(repeating: false, count: maxInputViews)
        state.isEnabledNextButton = count == 4
        
        for index in 0..<min(count, maxInputViews) {
          inputViews[index] = true
        }
        
        state.firstInputView = inputViews[0]
        state.secondInputView = inputViews[1]
        state.thirdInputView = inputViews[2]
        state.fourthInputView = inputViews[3]
        
        return .none
      case let .focus(isFocus):
        if state.isIncorrectCode && isFocus {
          state.isIncorrectCode = false
          state.isConfirmCode = false
          state.code = ""
          state.firstInputView = false
          state.secondInputView = false
          state.thirdInputView = false
          state.fourthInputView = false
        }
        state.isFocus = isFocus
        return .none
      case .codeCheck:
        state.isConfirmCode = true
        if state.code == "1028" {
          
          let format = DateFormatter()
          format.dateFormat = "yyyy-MM-dd HH:mm:ss"
          format.locale = Locale(identifier: "ko_KR")
          format.timeZone = TimeZone(abbreviation: "KST")
          
          let calendar = Calendar.current
          let currenTime = Date()
          
          if let sessionTime = format.date(from: state.session.date),
             let startTime = calendar.date(byAdding: .minute, value: -5, to: sessionTime),
             let endTime = calendar.date(byAdding: .minute, value: 5, to: sessionTime),
             let lateTime = calendar.date(byAdding: .minute, value: 30, to: sessionTime)
          {
            if startTime <= currenTime, lateTime > currenTime {
              if endTime > currenTime {
                return .send(.setAttendance(.normal))
              } else {
                return .send(.setAttendance(.late))
              }
            } else {
              return .send(.setAttendance(.absent))
            }
            
          } else {
            return .send(.sendError)
          }
        } else {
          return .run { send in
            await send(.incorrectCode)
          }
        }
      case let .setAttendance(status):
        
        if var member = state.member {
          let index = state.session.sessionId
          member.attendances[index].status = status
          
          memberInfo.updateMemberAttendances(memberId: member.id, attendances: member.attendances)
          
          return .send(.completeAttendance(member))
        } else {
          return .send(.sendError)
        }
      case .incorrectCode:
        state.isIncorrectCode = true
        state.isFocus = false
        return .none
      default:
        return .none
      }
    }
  }
}
