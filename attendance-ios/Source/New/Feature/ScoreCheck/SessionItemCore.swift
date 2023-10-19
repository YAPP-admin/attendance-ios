//
//  SessionItemCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/20.
//

import Foundation

import ComposableArchitecture

struct SessionItem: ReducerProtocol {
  
  struct State: Equatable, Identifiable {
    
    var id: Int {
      session.sessionId
    }
    
    let session: Session
    let status: SessionStatus
    
    var sessionDate: String {
      let dateFormatter = DateFormatter()
      let sessionDateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let date = dateFormatter.date(from: session.date)
      sessionDateFormatter.dateFormat = "MM.dd"
      return sessionDateFormatter.string(from: date ?? Date())
    }
    
    init(
      session: Session,
      status: SessionStatus
    ) {
      self.session = session
      self.status = status
    }
  }
  
  enum Action: Equatable {
    
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
