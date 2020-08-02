//
//  LoggedInRouter.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs

protocol LoggedInInteractable: Interactable, HomeListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    
    // ViewableRouting 에서 옴
    private let viewController: LoggedInViewControllable
    
    private let homeBuilder: HomeBuildable
    private var homeRouting: HomeRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedInInteractable,
         viewController: LoggedInViewControllable,
         homeBuilder: HomeBuildable) {
        self.viewController = viewController
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanUpViews() {
        //
    }
    
    override func didLoad() {
        super.didLoad()
        routeToHome()
    }
    
    func routeToHome() {
        // Listener를 Routing이 채택을 해야 build 파라메터에 interactor를 넣을 수 있다.
        // 즉 자식이 Listender에 선언한 부모의 행동을 부모에서 알아야 가능하다는 말
        let homeRouting = homeBuilder.build(withListener: interactor)
        self.homeRouting = homeRouting
        attachChild(homeRouting)
        let navigationController = UINavigationController(root: homeRouting.viewControllable)
        viewController.present(viewController: navigationController)
    }
    
    func detachHome() {
        guard let homeRouting = homeRouting else { return }
        detachChild(homeRouting)
        
        if let navigationController = homeRouting.viewControllable.uiviewController.navigationController {
            viewController.dismiss(viewController: navigationController)
        } else {
            viewController.dismiss(viewController: homeRouting.viewControllable)
        }
        self.homeRouting = nil
    }
    
}
