//
//  String+Extension.swift
//  OntheMap
//
//  Created by Ramiz Raja on 12/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidUrl() -> Bool {
        guard !self.isEmpty else { return false }
        guard let url = URL(string: self) else { return false }
        
        return UIViewController.canOpenUrl(url: url)
    }
}
