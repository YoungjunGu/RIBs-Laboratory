//
//  LoggedInInteractor.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedInRouting: Routing {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func cleanUpViews()
    func routeToHome()
    func detachHome()
}

// ViewLess 이기 때문에 필요 없다.
//protocol LoggedInPresentable: Presentable {
//    var listener: LoggedInPresentableListener? { get set }
//    // TODO: Declare methods the interactor can invoke the presenter to present data.
//}

protocol LoggedInListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func logOut()
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        router?.cleanUpViews()
    }
    
    func logOut() {
        FirebaseManager.logout()
        router?.detachHome()
        listener?.logOut()
    }
}
