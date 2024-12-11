//
//  UserDefaultsUtility.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 11/12/2024.
//

import Foundation

class UserDefaultsUtility {
    static let shared = UserDefaultsUtility()
    
    private let defaults = UserDefaults.standard
    
    func save<T: Codable>(key: String, value: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    func get<T: Codable>(key: String, type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
