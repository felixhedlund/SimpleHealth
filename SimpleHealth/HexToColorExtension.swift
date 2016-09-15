//
//  HexToColorExtension.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 13/09/2016.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import UIKit

extension UIColor{
    static func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        let hexint = Int(self.intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static private func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: NSScanner = NSScanner(string: hexStr)
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
        scanner.scanHexInt(&hexInt)
        return hexInt
    }
}