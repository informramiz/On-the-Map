//
//  UIView+Extension.swift
//  OntheMap
//
//  Created by Ramiz Raja on 19/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    var startY: CGFloat {
        var y: CGFloat = 0.0
        //start with the current view and keep going
        //up the view hierarchy till you find the last parent view
        //and keep adding the Ys of all because each child view
        //gives its start Y with respect to its parent View
        var view: UIView? = self
        while view != nil {
            y += view!.frame.origin.y
            view = view!.superview
        }
        return y
    }
    
    var endY: CGFloat {
        return startY + frame.height
    }
    
    var rootView: UIView {
        var view: UIView = self
        while view.superview != nil {
            view = view.superview!
        }
        return view
    }
    
    func isObscuredByKeyboard(keyboardHeight: CGFloat) -> Bool {
        let keyboardStartY = rootView.frame.height - keyboardHeight - 5
        return endY > keyboardStartY
    }
    
    private func moveRootViewUpBy(_ yDiff: CGFloat) {
        rootView.frame.origin.y -= yDiff
    }
    
    func keyboardWillShow(keyboardHeight: CGFloat) {
        //add extra 5 just to have some space between keyboard and text field
        let keyboardStartY = rootView.frame.height - keyboardHeight - 5
        //check if current text field is ending after the start of the keyboard view
        if endY > keyboardStartY {
            //as text field ends after the start of the keyboard, meaning it is being
            //obscured by the keyboard.
            
            //calculate how much it is being obscured
            let yDiff = endY - keyboardStartY
            //move the root view up by the amount by which text field is being obscured
            moveRootViewUpBy(yDiff)
        }
    }
    
    fileprivate func resetMainViewToNormalHeight() {
        rootView.frame.origin.y = 0
    }
    
    func keyboardWillHide() {
        resetMainViewToNormalHeight()
    }
}
