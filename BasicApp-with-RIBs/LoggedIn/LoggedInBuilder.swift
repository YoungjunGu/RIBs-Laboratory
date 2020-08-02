//
//  LoggedInBuilder.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs

protocol LoggedInDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var loggedInViewController: LoggedInViewControllable { get }
}

final class LoggedInComponent: Component<LoggedInDependency>, HomeDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    fileprivate var loggedInViewController: LoggedInViewControllable {
        return dependency.loggedInViewController
    }
    
    let email: String
    init(dependency: LoggedInDependency, email: String) {
        self.email = email
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener, email: String) -> LoggedInRouting
}

final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedInListener, email: String) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency, email: email)
        
        let interactor = LoggedInInteractor()
        interactor.listener = listener
        // dependency를 해당 하위 RIB에 추가 하고 싶으면 자신 RIB의 Component에 해당 RIB의 Dependency프로토콜을 채택해야한다.
        let homeBuiler = HomeBuilder(dependency: component)
        return LoggedInRouter(interactor: interactor,
                              viewController: component.loggedInViewController,
                              homeBuilder: homeBuiler)
    }
}
