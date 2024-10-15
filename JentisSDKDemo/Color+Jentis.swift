//
//  Color+Jentis.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 15/10/2024.
//

import SwiftUI

extension Color {
    // Custom initializer to support hex string
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    // Define your custom color
    static let jentisBlue = Color(hex: "#007FC8")
}
