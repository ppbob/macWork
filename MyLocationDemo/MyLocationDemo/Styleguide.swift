//
//  Styleguide.swift
//
//  Created by Göksel Köksal on 18/06/16.
//  Copyright © 2016 Mangu. All rights reserved.
//

import UIKit

enum Color {
    static let black = UIColor.black
    static let green = UIColor.green
    static let blue = UIColor.blue
    static let red = UIColor.red
    static let clear = UIColor.clear
}

enum Alpha {
    static let none     = CGFloat(0.0)
    static let veryLow  = CGFloat(0.05)
    static let low      = CGFloat(0.30)
    static let medium1  = CGFloat(0.40)
    static let medium2  = CGFloat(0.50)
    static let medium3  = CGFloat(0.60)
    static let high     = CGFloat(0.87)
    static let full     = CGFloat(1.0)
}

enum Font {
    static func withSize(_ size: CGFloat, weight: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight(rawValue: weight))
    }
}

extension TextStyle {
    
    static let body = TextStyle(
        font: Font.withSize(15.0, weight: UIFont.Weight.regular.rawValue),
        color: Color.red
    )
    
    static let title = TextStyle(
        font: Font.withSize(20.0, weight: UIFont.Weight.light.rawValue),
        color: Color.black
    )
}

extension TextStyle {
    
    enum Button {
        static let action = TextStyle(
            font: Font.withSize(30.0, weight: UIFont.Weight.medium.rawValue),
            color: Color.green
        )
    }
}

extension ViewStyle {
    
    enum View {
        static let action = ViewStyle(
            backgroundColor: Color.green,
            tintColor: Color.green, layerStyle: LayerStyle(
                masksToBounds: true,
                cornerRadius: 0.2, borderStyle: LayerStyle.BorderStyle(
                    color: Color.green, width: 100),
     shadowStyle: LayerStyle.ShadowStyle(
                color: Color.green,
        radius: 0.9, offset:CGSize(), opacity: 0.8)
            )
        )
    }
}
