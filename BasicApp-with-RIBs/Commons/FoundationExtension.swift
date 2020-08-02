//
//  FoundationExtension.swift
//  BasicApp-with-RIBs
//
//  Created by youngjun goo on 2020/08/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

extension String {
    func removeSpecialCharacters() -> String {
        return self.components(separatedBy: CharacterSet.letters.inverted).joined()
    }
}
