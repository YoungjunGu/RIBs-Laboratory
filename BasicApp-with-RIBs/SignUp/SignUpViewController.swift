//
//  SignUpViewController.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

protocol SignUpPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func navigationBackDidTap()
    func signUpDidTap(email: String, password: String)
    
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField? {
        didSet {
            passwordTextField?.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var signUpButton: UIButton? {
        didSet {
            signUpButton?.backgroundColor = .gray
        }
    }
    
    weak var listener: SignUpPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            listener?.navigationBackDidTap()
        }
    }
    
    private func bind() {
        Observable.combineLatest((emailTextField?.rx.text.orEmpty)!,
                                 (passwordTextField?.rx.text.orEmpty)!)
        { (email, password) -> Bool in
            return LogInTextFormManager.isValidEmail(email) && LogInTextFormManager.isValidpassword(password)
        }.subscribe(onNext: { [weak self] isValid in
            self?.signUpButton?.isEnabled = isValid
            self?.signUpButton?.backgroundColor = .blue
        }).disposed(by: disposeBag)
        
        signUpButton?.rx.tap.map { [weak self] _ in
            return (self?.emailTextField?.text ?? "", self?.passwordTextField?.text ?? "")
        }.subscribe(onNext: { [weak self] email, password in
            self?.listener?.signUpDidTap(email: email, password: password)
        }).disposed(by: disposeBag)
    }
}
