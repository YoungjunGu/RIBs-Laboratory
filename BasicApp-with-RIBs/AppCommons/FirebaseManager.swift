//
//  FirebaseManager.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import Firebase
import RxSwift

typealias AuthHandler = (Result<AuthDataResult, Error>) -> Void

protocol FirebaseAuthorable {
    static func signUp(email: String, password: String, completion: @escaping AuthHandler)
    static func login(email: String, password: String, completion: @escaping AuthHandler)
    static func logout()
}

class FirebaseManager {
    
    class var isLogin: Bool {
        return Auth.auth().currentUser != nil ? true : false
    }
    
    class var user: String {
        return Auth.auth().currentUser?.email?.removeSpecialCharacters() ?? ""
    }
    
    class var userEmail: String {
        return Auth.auth().currentUser?.email ?? ""
    }
}

extension FirebaseManager: FirebaseAuthorable {
    
    class func signUp(email: String, password: String, completion: @escaping AuthHandler) {
        Auth.auth().createUser(withEmail: email,
                               password: password)
        { (result, error) in
            if let result = result {
                completion(.success(result))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    class func login(email: String, password: String, completion: @escaping AuthHandler) {
        Auth.auth().signIn(withEmail: email,
                           password: password)
        { (result, error) in
            if let result = result {
                completion(.success(result))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
   class func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            // error handling
        }
    }
}
