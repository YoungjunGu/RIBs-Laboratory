//
//  LoggedOutRouter.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs

protocol LoggedOutInteractable: Interactable, SignUpListener {
    var router: LoggedOutRouting? { get set }
    var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func push(viewController: ViewControllable)
}

final class LoggedOutRouter: ViewableRouter<LoggedOutInteractable, LoggedOutViewControllable>, LoggedOutRouting {
    
    private let signUpBuilder: SignUpBuildable
    private var signUpRouting: SignUpRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedOutInteractable,
                  viewController: LoggedOutViewControllable,
                  signUpBuilder: SignUpBuildable) {
        self.signUpBuilder = signUpBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToSignUp() {
        let signUpRouting = signUpBuilder.build(withListener: interactor)
        self.signUpRouting = signUpRouting
        attachChild(signUpRouting)
        viewController.push(viewController: signUpRouting.viewControllable)
    }
    
    func detachSignUp() {
        if let signUpRouting = signUpRouting {
            detachChild(signUpRouting)
            self.signUpRouting = nil
        }
    }
}
