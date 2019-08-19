//
//  HideKeyboardOnEnterDelegate.swift
//  OntheMap
//
//  Created by Ramiz Raja on 19/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
import UIKit

class HideKeyboardOnEnterDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keyboard when user press enter
        textField.resignFirstResponder()
        return false
    }
}
