//
//  SignUpRouter.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs

protocol SignUpInteractable: Interactable {
    var router: SignUpRouting? { get set }
    var listener: SignUpListener? { get set }
}

protocol SignUpViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SignUpRouter: ViewableRouter<SignUpInteractable, SignUpViewControllable>, SignUpRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SignUpInteractable, viewController: SignUpViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
