//
//  PushData.swift
//  JentisSDK
//
//  Created by Alexandre Oliveira on 01/11/2024.
//

import Foundation

struct PushPayload: Codable {
    let track: String
    let type: String
    let customProperties: [String: String]
}

struct PushData {
    private var data: [String: String] = [:]
    private let reservedKeys: Set<String> = ["track", "type"]
    
    init(customProperties: [String: Any]) {
        for (key, value) in customProperties {
            guard !reservedKeys.contains(key) else {
                print("Warning: \(key) is a reserved key and cannot be set.")
                continue
            }
            if let stringValue = value as? String {
                data[key] = stringValue
            } else {
                print("Warning: Only String values are allowed for custom properties.")
            }
        }
    }
    
    func getProperties() -> [String: String] {
        return data
    }
}
