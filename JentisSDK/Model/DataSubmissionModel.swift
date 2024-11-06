//
//  DataSubmissionModel.swift
//  JentisSDK
//
//  Created by Alexandre Oliveira on 11/10/2024.
//

import Foundation

// MARK: - DataSubmissionModel
struct DataSubmissionModel: Codable {
    let version: String
    let system: System
    let consent: Consent
    let configuration: Configuration
    let data: DataClass
    
    // MARK: - System
    struct System: Codable {
        let type: String
        let timestamp: Int
        let navigatorUserAgent: String
        let initiator: String
        let sessionID: String
        
        enum CodingKeys: String, CodingKey {
            case type, timestamp
            case navigatorUserAgent = "navigator-userAgent"
            case initiator
            case sessionID
        }
    }
    
    // MARK: - Consent
    struct Consent: Codable {
        let googleAnalytics: Vendor
        let facebook: Vendor
        let awin: Vendor
        
        enum CodingKeys: String, CodingKey {
            case googleAnalytics = "googleanalytics"
            case facebook, awin
        }
        
        struct Vendor: Codable {
            let status: StatusValue
        }
        
        enum StatusValue: Codable {
            case string(String)
            case bool(Bool)
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let boolValue = try? container.decode(Bool.self) {
                    self = .bool(boolValue)
                } else if let stringValue = try? container.decode(String.self) {
                    self = .string(stringValue)
                } else {
                    throw DecodingError.typeMismatch(StatusValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode StatusValue"))
                }
            }
            
            func encode(to encoder: Encoder) throws {
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
    
    struct Configuration: Codable {
        let container: String
        let environment: String
        let version: String
        let debugcode: String
    }
    
    struct DataClass: Codable {
        let identifier: Identifier
        let variables: Variables
        let enrichment: Enrichment
        
        struct Identifier: Codable {
            let user: User
            let session: Session
            
            struct User: Codable {
                let id: String
                let action: String
            }
            
            struct Session: Codable {
                let id: String
                let action: String
            }
        }
        
        struct Variables: Codable {
            let documentLocationHref: String
            let fbBrowserId: String
            let jtspushedcommands: [String]
            let productId: [String]
            var customProperties: [String: String]
            
            enum CodingKeys: String, CodingKey {
                case documentLocationHref = "document_location_href"
                case fbBrowserId = "fb_browser_id"
                case jtspushedcommands
                case productId = "product_id"
            }
            
            init(
                documentLocationHref: String,
                fbBrowserId: String,
                jtspushedcommands: [String],
                productId: [String],
                customProperties: [String: String] = [:]
            ) {
                self.documentLocationHref = documentLocationHref
                self.fbBrowserId = fbBrowserId
                self.jtspushedcommands = jtspushedcommands
                self.productId = productId
                self.customProperties = customProperties
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                documentLocationHref = try container.decode(String.self, forKey: .documentLocationHref)
                fbBrowserId = try container.decode(String.self, forKey: .fbBrowserId)
                jtspushedcommands = try container.decode([String].self, forKey: .jtspushedcommands)
                productId = try container.decode([String].self, forKey: .productId)
                
                // Decode dynamic custom properties
                let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
                customProperties = [:]
                for key in dynamicContainer.allKeys {
                    if CodingKeys(stringValue: key.stringValue) == nil {
                        let value = try dynamicContainer.decode(String.self, forKey: key)
                        customProperties[key.stringValue] = value // Overwrites if the key is duplicated
                    }
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(documentLocationHref, forKey: .documentLocationHref)
                try container.encode(fbBrowserId, forKey: .fbBrowserId)
                try container.encode(jtspushedcommands, forKey: .jtspushedcommands)
                try container.encode(productId, forKey: .productId)
                
                // Encode custom properties dynamically
                var dynamicContainer = encoder.container(keyedBy: DynamicCodingKey.self)
                for (key, value) in customProperties {
                    let dynamicKey = DynamicCodingKey(stringValue: key)!
                    try dynamicContainer.encode(value, forKey: dynamicKey)
                }
            }
        }
        
        struct Enrichment: Codable {
            let enrichmentXxxlprodfeed: EnrichmentXxxlprodfeed
            
            enum CodingKeys: String, CodingKey {
                case enrichmentXxxlprodfeed = "enrichment_xxxlprodfeed"
            }
            
            struct EnrichmentXxxlprodfeed: Codable {
                let arguments: Arguments
                let variables: [String]
                
                struct Arguments: Codable {
                    let account: String
                    let productId: [String]
                    let baseProductId: [String]
                }
            }
        }
    }
}

// Wrapper to assist with custom properties
public struct VariablesWrapper {
    public let documentLocationHref: String
    public let fbBrowserId: String
    public let jtspushedcommands: [String]
    public let productId: [String]
    public let customProperties: [String: String]
    
    public init(
        documentLocationHref: String,
        fbBrowserId: String,
        jtspushedcommands: [String],
        productId: [String],
        customProperties: [String: String] = [:]
    ) {
        self.documentLocationHref = documentLocationHref
        self.fbBrowserId = fbBrowserId
        self.jtspushedcommands = jtspushedcommands
        self.productId = productId
        self.customProperties = customProperties
    }
    
    func toDataSubmissionModelVariables() -> DataSubmissionModel.DataClass.Variables {
        return DataSubmissionModel.DataClass.Variables(
            documentLocationHref: documentLocationHref,
            fbBrowserId: fbBrowserId,
            jtspushedcommands: jtspushedcommands,
            productId: productId,
            customProperties: customProperties
        )
    }
}

// Dynamic Coding Key to handle custom keys
struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int? { nil }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}
