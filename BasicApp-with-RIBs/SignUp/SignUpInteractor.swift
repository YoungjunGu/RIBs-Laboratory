//
//  SignUpInteractor.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs
import RxSwift

protocol SignUpRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}
// 내부에 listener객체를 가지고 있다.
protocol SignUpPresentable: Presentable {
    var listener: SignUpPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SignUpListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func navigationBack()
    func signUpAndLoginDidSuccess(email: String)
}
// 1. PresentableListener(VC의 비지니스 로직)을 Interactor가 채택하여
final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable, SignUpPresentableListener {
    
    weak var router: SignUpRouting?
    weak var listener: SignUpListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SignUpPresentable) {
        super.init(presenter: presenter)
        // 2. init시에 Presentable을 초기화 하게 됩니다.
        // delegate pattern 의 형식 -> self로 위임을 하게 됩니다. 어디에? Interactor에
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - SIgnUpPresentableListener
    
    func navigationBackDidTap() {
        listener?.navigationBack()
    }
    
    func signUpDidTap(email: String, password: String) {
        FirebaseManager.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                AlertNavigator.presentAlert(with: "회원가입완료", action: { _ in
                    self?.listener?.signUpAndLoginDidSuccess(email: email)
                })
            case .failure(let error):
                AlertNavigator.presentAlert(with: error.localizedDescription)
            }
        }
    }
}
