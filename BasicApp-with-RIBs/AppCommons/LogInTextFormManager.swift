//
//  LogInTextFormManager.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

class LogInTextFormManager {
    class func isValidEmail(_ email: String) -> Bool {
        return email.count >= 5
    }
    
    class func isValidpassword(_ password: String) -> Bool {
        return password.count >= 5
    }
}
