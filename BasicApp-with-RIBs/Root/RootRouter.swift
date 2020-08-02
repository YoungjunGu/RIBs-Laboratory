//
//  RootRouter.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs
import Firebase

protocol RootInteractable: Interactable, LoggedInListener, LoggedOutListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // VC에 어떤행위를 할 지 정의
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouting: LoggedOutRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouting: LoggedInRouting?

    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         loggedOutBuilder: LoggedOutBuildable,
         loggedInBuilder: LoggedInBuildable) {
        // 순서 중요
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        route()
    }
    
    private func route() {
        if FirebaseManager.isLogin {
            routeToLoggedIn(email: FirebaseManager.userEmail)
        } else {
            routeToLoggedOut()
        }
    }
}

// MARK: - RootRouting

extension RootRouter {
    
    func routeToLoggedOut() {
        // 중요! 만약 loggedInRouting이 valid 하면 LoggedInRouting을 detach 작업부터
        if let loggedInRouting = loggedInRouting {
            detachChild(loggedInRouting)
            self.loggedInRouting = nil
        }
        
        let loggedOutRouting = loggedOutBuilder.build(withListener: interactor)
        self.loggedOutRouting = loggedOutRouting
        // loggedOut attach
        attachChild(loggedOutRouting)
        // Routing안에 viewControllalbe 추가
        let navigationController = UINavigationController(root: loggedOutRouting.viewControllable)
        viewController.present(viewController: navigationController)
    }
    
    func routeToLoggedIn(email: String) {
        if let loggedOutRouting = loggedOutRouting {
            detachChild(loggedOutRouting)
            if let navigationController = loggedOutRouting.viewControllable.uiviewController.navigationController {
                viewController.dismiss(viewController: navigationController)
            } else {
                viewController.dismiss(viewController: loggedOutRouting.viewControllable)
            }
            self.loggedOutRouting = nil
        }
        
        let loggedInRouting = loggedInBuilder.build(withListener: interactor, email: email)
        self.loggedInRouting = loggedInRouting
        attachChild(loggedInRouting)
    }
}
