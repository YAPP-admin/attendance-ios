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
    }

    struct Output {
        var goToHome = PublishRelay<Void>()
        let goToPolicyVC = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    var documentID = BehaviorRelay<String>(value: "")
    var memberData = BehaviorRelay<Member?>(value: nil)

    init() {
        input.tapBack
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToHome.accept(())
            }).disposed(by: disposeBag)

        input.tapPolicyView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToPolicyVC.accept(())
            }).disposed(by: disposeBag)

        getCollections()
    }
}

private extension SettingViewModel {
    func getCollections() {
//        let docRef = db.collection("member").document("20th")
//        docRef.collection("members").getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                if let querySnapshot = querySnapshot {
//                    for document in querySnapshot.documents {
//                        self.documentID.accept("\(document.documentID)")
//                        let id = document.data()["id"] as? Int ?? 0
//                        let isAdmin = document.data()["isAdmin"] as? Bool ?? false
//                        let name = document.data()["name"] as? String ?? ""
//                        let position = document.data()["position"] as? String ?? ""
//                        let team = document.data()["team"] as? String ?? ""
//                        self.memberData.accept(Member(id: id, isAdmin: isAdmin, name: name, position: position, team: team))
//                    }
//                }
//            }
//        }
    }
}
