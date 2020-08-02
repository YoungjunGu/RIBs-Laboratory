//
//  LoggedOutViewController.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

// 이거 먼저 설계 후에 Interactor 작업이 들어가야 한다.
//
protocol LoggedOutPresentableListener: class {
    func loginDidTap(email: String, password: String)
    func moveSignUpDidTap()
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField? {
        didSet {
            passwordTextField?.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var logInButton: UIButton?
    @IBOutlet weak var signUpButton: UIButton?
    
    weak var listener: LoggedOutPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        bind()
    }
    
    private func setNavigationController() {
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.title = "Gaki RIBs"
    }
    
    private func bind() {
        
        Observable.combineLatest((emailTextField?.rx.text.orEmpty)!,
                                 (passwordTextField?.rx.text.orEmpty)!) { (email, password) -> Bool in
                                    return LogInTextFormManager.isValidEmail(email) &&
                                        LogInTextFormManager.isValidpassword(password)
        }
        .subscribe(onNext: { [weak self] isValid in
            self?.logInButton?.isEnabled = isValid
        }).disposed(by: disposeBag)
        // LoginButton Binding
        logInButton?.rx.tap
            .map { [weak self] _ in
                return (self?.emailTextField?.text ?? "", self?.passwordTextField?.text ?? "")
        }
        .subscribe(onNext: { [weak self] email, password in
            self?.listener?.loginDidTap(email: email, password: password)
        }).disposed(by: disposeBag)
        // SignUpButton Binding
        signUpButton?.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.listener?.moveSignUpDidTap()
        }).disposed(by: disposeBag)
    }
}

// MARK: - LoggedOutViewControllable
extension LoggedOutViewController {
    func push(viewController: ViewControllable) {
        self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }
}
