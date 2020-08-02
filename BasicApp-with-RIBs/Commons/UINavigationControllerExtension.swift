//
//  UINavigationControllerExtension.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import RIBs

extension UINavigationController: ViewControllable {
    public var uiViewController: UIViewController { return self }
    
    convenience init(root: ViewControllable) {
        self.init(rootViewController: root.uiviewController)
    }
}
