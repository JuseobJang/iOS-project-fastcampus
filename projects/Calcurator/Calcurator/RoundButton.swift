//
//  RoundButton.swift
//  Calcurator
//
//  Created by seob_jj on 2021/09/04.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
   @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }



}
