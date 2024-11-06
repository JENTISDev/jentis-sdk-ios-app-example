//
//  ConsentStatus.swift
//  JentisSDK
//
//  Created by Alexandre Oliveira on 02/11/2024.
//
import Foundation

public enum ConsentStatus {
    case allow
    case deny
    case ncm
    
    public var toVendorValue: ConsentModel.DataClass.Consent.VendorValue {
        switch self {
        case .allow:
            return .bool(true)
        case .deny:
            return .bool(false)
        case .ncm:
            return .string("ncm")
        }
    }
}
