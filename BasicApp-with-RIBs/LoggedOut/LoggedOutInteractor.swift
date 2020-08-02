//
//  LoggedOutInteractor.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToSignUp()
    func detachSignUp()
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LoggedOutListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func login(email: String)
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: LoggedOutPresentable) {
        super.init(presenter: presenter)
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
    
    func loginDidTap(email: String, password: String) {
        FirebaseManager.login(email: email, password: password, completion: { [weak self] result in
            switch result {
            case .success:
                self?.listener?.login(email: email)
            case .failure(let error):
                AlertNavigator.presentAlert(with: error.localizedDescription)
            }
        })
    }
    
    func moveSignUpDidTap() {
        router?.routeToSignUp()
    }
    
    func navigationBack() {
        router?.detachSignUp()
    }
    
    func signUpAndLoginDidSuccess(email: String) {
        router?.detachSignUp()
        listener?.login(email: email)
    }
    
}
