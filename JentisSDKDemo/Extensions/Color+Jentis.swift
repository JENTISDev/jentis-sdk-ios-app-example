//
//  Color+Jentis.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 15/10/2024.
//

import SwiftUI

extension Color {
    // Custom initializer to support hex string with optional alpha
    init(hex: String, alpha: Double = 1.0) {
        // Sanitize input string
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            // Fallback to a default color (black) in case of invalid input
            self.init(.black)
            return
        }
        
        let length = hexSanitized.count
        let red, green, blue, calculatedAlpha: Double
        
        switch length {
        case 6: // #RRGGBB
            red = Double((rgb >> 16) & 0xFF) / 255.0
            green = Double((rgb >> 8) & 0xFF) / 255.0
            blue = Double(rgb & 0xFF) / 255.0
            calculatedAlpha = alpha
        case 8: // #RRGGBBAA
            red = Double((rgb >> 24) & 0xFF) / 255.0
            green = Double((rgb >> 16) & 0xFF) / 255.0
            blue = Double((rgb >> 8) & 0xFF) / 255.0
            calculatedAlpha = Double(rgb & 0xFF) / 255.0
        default:
            // Fallback to a default color (black) in case of invalid length
            self.init(.black)
            return
        }
        
        self.init(red: red, green: green, blue: blue, opacity: calculatedAlpha)
    }
    
    // Define your custom colors
    static let brandBlue = Color(hex: "#0068A3")
    static let mainBlue = Color(hex: "#0068A3")
    static let mainDark = Color(hex: "#212121")
    static let secondaryDark = Color(hex: "#616161")
    static let gray = Color(hex: "#888888")
    static let lightGray = Color(hex: "#D1D1D1")
    static let brandGreen = Color(hex: "#65C466")
    static let mediumGray = Color(hex: "#878787")
}
