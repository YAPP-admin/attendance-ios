//
//  HomeTabCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture
import SwiftUI

struct HomeTab: ReducerProtocol {
  
  enum Tab { case todaySession, qr, scoreCheck}
  
  struct State: Equatable {
    var todaySession: TodaySession.State
    var scoreCheck: ScoreCheck.State
    
    @BindingState var selectedTab: Tab
    
    @PresentationState var destination: Destination.State?
    
    @BindingState var isShowToast: Bool = false
    var toastMessage: String = ""
    
    var member: Member?
    
    init(member: Member?, selectTab: Tab) {
      self.todaySession = TodaySession.State(member: member)
      self.scoreCheck = ScoreCheck.State(member: member)
      selectedTab = selectTab
      self.member = member
    }
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    
    case todaySession(TodaySession.Action)
    case scoreCheck(ScoreCheck.Action)
    case tappedSettingButton(Member?)
    case setMember(Member?)
    
    case tappedAttendanceButton
    case attendanceCheck(Session?)
    case attendanceTimeCheck(Session?)
    
    case showToast(String)
    case showAttendanceCode(Session)
  }
  
  public struct Destination: ReducerProtocol {
    public enum State: Equatable {
      case attendanceCode(AttendanceCode.State)
      case alert(AlertState<Action.Alert>)
    }
    
    public enum Action: Equatable {
      case attendanceCode(AttendanceCode.Action)
      case alert(Alert)
      
      public enum Alert {
        case cancel
      }
    }
    
    public var body: some ReducerProtocolOf<Self> {
      Scope(state: /State.attendanceCode, action: /Action.attendanceCode) {
        AttendanceCode()
      }
    }
  }
  
  @Dependency(\.sessionInfo.sessionInfo) var sessionInfo
  
  var body: some ReducerProtocolOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .tappedSettingButton:
        return .none
      case let .setMember(member):
        state.member = member
        return .none
      case .tappedAttendanceButton:
        
        return .run { send in
          let session = try await sessionInfo.todaySession()
          
          await send(.attendanceCheck(session))
          
        } catch: { error, send in
            await send(.showToast("에러가 발생했습니다."))
        }
      case let .attendanceCheck(session):
        var isAttendanced: Bool = true
        if let session = session,
           let member = state.member {
          member.attendances.forEach {
            if $0.sessionId == session.sessionId {
              if $0.status == .absent {
                isAttendanced = false
              } else {
                isAttendanced = true
              }
            }
          }
        }
        
        if isAttendanced == false {
          return .send(.attendanceTimeCheck(session))
        } else {
          return .send(.showToast("이미 출석을 완료했어요."))
        }
      
      case let .attendanceTimeCheck(session):
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        
        let calendar = Calendar.current
        let currenTime = Date()
        
        if let session = session,
           let sessionTime = format.date(from: session.date),
           let startTime = calendar.date(byAdding: .minute, value: -5, to: sessionTime),
           let endTime = calendar.date(byAdding: .minute, value: 30, to: sessionTime),
           startTime <= currenTime,
           endTime > currenTime
        {
          return .send(.showAttendanceCode(session))
        } else {
          return .send(.showToast("지금은 출석할 수 없어요."))
        }
      case let .showToast(message):
        
        state.toastMessage = message
        state.isShowToast = true
        
        return .none
        
      case let .showAttendanceCode(session):
    
        state.destination = .attendanceCode(AttendanceCode.State(session: session, member: state.member))
        
        return .none
        
      case .destination(.presented(.attendanceCode(.dismissScene))):
        
        state.destination = nil
        
        return .none
        
      case let .destination(.presented(.attendanceCode(.completeAttendance(member)))):
        
        state.destination = nil
        state.member = member
        
        return .run { send in
          await send(.todaySession(.setMember(member)))
          await send(.scoreCheck(.setMember(member)))
        }
      
      case .destination(.presented(.attendanceCode(.sendError))):
        
        state.destination = nil
        
        return .send(.showToast("에러가 발생했습니다."))
        
      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
    
    Scope(state: \.todaySession, action: /Action.todaySession) {
      TodaySession()
    }
    
    Scope(state: \.scoreCheck, action: /Action.scoreCheck) {
      ScoreCheck()
    }
  }
}
