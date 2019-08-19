//
//  ViewController+Extension.swift
//  OntheMap
//
//  Created by Apple on 22/07/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func openUrl(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController()
        alertController.title = title
        alertController.message = message
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    static func canOpenUrl(url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    func subscribeToKeyboardNotifications(keyboardWillShow: Selector, keyboardWillHide: Selector? = nil) {
        NotificationCenter.default.addObserver(self, selector: keyboardWillShow, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: keyboardWillHide ?? #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        resetMainViewHeightToNormal()
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func moveMainViewUpBy(height: CGFloat) {
        view.frame.origin.y -= height
    }
    
    func resetMainViewHeightToNormal() {
        view.frame.origin.y = 0
    }
}
