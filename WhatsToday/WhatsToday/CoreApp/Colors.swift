//
//  Colors.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/11/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

struct ColorAssets {
    static let appTint = UIColor(named: "appTint", in: Bundle(for: AppDelegate.self), compatibleWith: nil)!
}

extension UIColor {
    
    /// Returns a brighter color by increasing brightnesss, and decreasing saturation.
    func colorBrighter(by brightnessFactor: CGFloat) -> UIColor? {
        print("Brightening by \(brightnessFactor*100)%")
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            print("Could not convert to HSB color space.")
            return nil
        }
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * (1 + brightnessFactor), alpha: alpha)
    }
}
