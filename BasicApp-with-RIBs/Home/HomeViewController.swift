//
//  HomeViewController.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

protocol HomePresentableListener: class {
    func logOutButtonDidTap()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    
    @IBOutlet weak var logOutButton: UIButton?

    weak var listener: HomePresentableListener?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        logOutButton?.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.listener?.logOutButtonDidTap()
            }).disposed(by: disposeBag)
    }
}
