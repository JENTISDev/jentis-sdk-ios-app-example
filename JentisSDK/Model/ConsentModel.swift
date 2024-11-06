//
//  ConsentModel.swift
//  JentisSDK
//
//  Created by Alexandre Oliveira on 11/10/2024.
//

import Foundation

public struct ConsentModel: Codable {
    public let version: String
    public let system: System
    public let configuration: Configuration
    public let data: DataClass
    
    // MARK: - System
    public struct System: Codable {
        public let type: String
        public let timestamp: Int
        public let navigatorUserAgent: String
        public let initiator: String
        
        public enum CodingKeys: String, CodingKey {
            case type, timestamp
            case navigatorUserAgent = "navigator-userAgent"
            case initiator
        }
    }
    
    // MARK: - Configuration
    public struct Configuration: Codable {
        public let container: String
        public let environment: String
        public let version: String
        public let debugcode: String
    }
    
    // MARK: - DataClass
    public struct DataClass: Codable {
        public let identifier: Identifier
        public let consent: Consent
        
        // MARK: - Identifier
        public struct Identifier: Codable {
            public let user: User
            public let consent: ConsentID
            
            // MARK: - User
            public struct User: Codable {
                public let id: String
                public let action: String
            }
            
            // MARK: - ConsentID
            public struct ConsentID: Codable {
                public let id: String
                public let action: String
            }
        }
        
        // MARK: - Consent
        public struct Consent: Codable {
            public let lastupdate: Int
            public let data: [String: String]
            public var vendors: [String: VendorValue]
            public var vendorsChanged: [String: VendorValue]
            
            // MARK: - VendorValue Enum
            public enum VendorValue: Codable {
                case bool(Bool)
                case string(String)
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    if let boolValue = try? container.decode(Bool.self) {
                        self = .bool(boolValue)
                    } else if let stringValue = try? container.decode(String.self) {
                        self = .string(stringValue)
                    } else {
                        throw DecodingError.typeMismatch(VendorValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode VendorValue"))
                    }
                }
                
                public func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()
                    switch self {
                    case .bool(let boolValue):
                        try container.encode(boolValue)
                    case .string(let stringValue):
                        try container.encode(stringValue)
                    }
                }
            }
        }
    }
}
