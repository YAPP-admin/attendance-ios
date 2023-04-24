//
//  SettingViewModel.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/30.
//

import RxCocoa
import RxSwift
import UIKit
import FirebaseFirestore

final class SettingViewModel: ViewModel {
    struct Input {
        let tapBack = PublishRelay<Void>()
        let tapPolicyView = PublishRelay<Void>()
        let tapLogoutView = PublishRelay<Void>()
        let tapMemberView = PublishRelay<Void>()
        let teamType = BehaviorSubject<TeamType?>(value: nil)
        let teamNumber = BehaviorSubject<Int?>(value: nil)
        let memberOut = PublishRelay<Void>()
        let updateInfo = PublishRelay<Void>()
    }

    struct Output {
        var goToHome = PublishRelay<Void>()
        let goToPolicyVC = PublishRelay<Void>()
        let goToLoginVC = PublishRelay<Void>()
        let showDialogWhenMemberOut = PublishRelay<Void>()
        let showToastWhenError = PublishRelay<Void>()
        var generation = BehaviorRelay<String>(value: "")
        var name = BehaviorRelay<String>(value: "")
        let isLoading = BehaviorSubject<Bool>(value: false)
        let showTeamNumber = PublishRelay<Void>()
        let complete = PublishRelay<Void>()
        let configTeams = BehaviorSubject<[Team]>(value: [])
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    let myId = BehaviorRelay<String>(value: "")
    var documentID = BehaviorRelay<String>(value: "")
    var memberData = BehaviorRelay<Member?>(value: nil)

    private let userDefaultsWorker = UserDefaultsWorker()
    private let firebaseWorker = FirebaseWorker()

    init() {
        input.tapBack
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToHome.accept(())
            }).disposed(by: disposeBag)

        input.tapPolicyView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToPolicyVC.accept(())
            }).disposed(by: disposeBag)

        input.tapLogoutView
            .subscribe(onNext: { [weak self] _ in
                self?.logout()
            }).disposed(by: disposeBag)

        input.tapMemberView
            .subscribe(onNext: { [weak self] _ in
                self?.output.showDialogWhenMemberOut.accept(())
            }).disposed(by: disposeBag)

        input.memberOut
            .subscribe(onNext: { [weak self] _ in
                self?.memberOut()
            }).disposed(by: disposeBag)

        checkLoginId()
        checkGeneration()
        setupName()
    }

    func checkGeneration() {
        if let generation = userDefaultsWorker.getGeneration(), generation.isEmpty == false {
            output.generation.accept(generation)
        }
    }

     func setupName() {
        if let name = userDefaultsWorker.getName(), name.isEmpty == false {
            output.name.accept(name)
        }
    }

    func logout() {
        output.goToLoginVC.accept(())
    }

    func memberOut() {
        guard let member = memberData.value else {
            self.output.goToLoginVC.accept(())
            return
        }

        firebaseWorker.deleteDocument(memberId: member.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.userDefaultsWorker.removeAllLoginId()
                self.output.goToLoginVC.accept(())
            case .failure:
                self.output.showToastWhenError.accept(())
            }
        }
    }

    func checkLoginId() {
        if let kakaoTalkId = userDefaultsWorker.getKakaoTalkId(), kakaoTalkId.isEmpty == false {
            myId.accept(kakaoTalkId)
            getUserData()
        } else if let appleId = userDefaultsWorker.getAppleId(), appleId.isEmpty == false {
            myId.accept(appleId)
            getUserData()
        } else if let guestId = userDefaultsWorker.getGuestId(), guestId.isEmpty == false {
            myId.accept(guestId)
            getUserData()
        }
    }

    func getUserData() {
        firebaseWorker.getMemberDocumentData(memberId: Int(myId.value) ?? 0) { result in
            switch result {
            case .success(let member):
                self.memberData.accept(member)
                self.userDefaultsWorker.setName(name: member.name)
            case .failure:
                self.output.goToLoginVC.accept(())
            }
        }
    }

}

extension SettingViewModel {
  func updateInfo() {
      guard let appleId = try? input.appleId.value(),
            let kakaoTalkId = try? input.kakaoTalkId.value(),
            let isGuest = try? input.isGuest.value(),
            let name = try? input.name.value(),
            let positionType = try? input.positionType.value() else { return }

          let newUser = FirebaseNewMember(name: name, positionType: positionType, teamType: TeamType.none, teamNumber: 1)

      if kakaoTalkId.isEmpty == false, let id = Int(kakaoTalkId) {
    userDefaultsWorker.setKakaoTalkId(id: kakaoTalkId)
          registerKakaoUserInfo(id: id, newUser: newUser)
      } else if appleId.isEmpty == false {
    userDefaultsWorker.setAppleId(id: appleId)
          registerWithApple(id: appleId, newUser: newUser)
      } else if isGuest == true {
          let randomId = Int.random(in: 1000000000..<10000000000)
          userDefaultsWorker.setGuestId(id: String(randomId))
          registerGuestUser(id: randomId, newUser: newUser)
      }
  }

  func registerKakaoUserInfo(id: Int, newUser: FirebaseNewMember) {
      firebaseWorker.registerKakaoUserInfo(id: id, newUser: newUser) { [weak self] result in
          switch result {
          case .success: self?.output.goToHome.accept(())
          case .failure: self?.output.goToLoginVC.accept(())
          }
      }
  }

  func registerWithApple(id: String, newUser: FirebaseNewMember) {
      firebaseWorker.registerAppleUserInfo(id: id, newUser: newUser) { [weak self] result in
          switch result {
          case .success: self?.output.goToHome.accept(())
          case .failure: self?.output.goToLoginVC.accept(())
          }
      }
  }
}
