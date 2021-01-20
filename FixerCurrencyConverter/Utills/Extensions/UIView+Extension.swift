/*
 *	UIView+Extension.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import UIKit

extension UIView {
    
    final class var name: String {
        return String(describing: self)
    }
    
    var frameWidth: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.size.height)
        }
    }
    
    var frameHeight: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: newValue)
        }
    }
}
