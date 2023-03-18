//
//  PropertyListSerializationError.swift
//
//
//  Created by Burak Colak on 18.03.2023.
//

import Foundation

public enum PropertyListSerializationError: Error {
    case fileNotFound
    case fileNotParsed
    case dataNotAvailable
    case modelNotParsed
    case configNotLoaded
}

extension PropertyListSerializationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return NSLocalizedString(String(format: "File %@.plist not found", "BAConfig"), comment: "")
        case .fileNotParsed:
            return NSLocalizedString("File could not be parsed", comment: "")
        case .dataNotAvailable:
            return NSLocalizedString("Data is not available", comment: "")
        case .modelNotParsed:
            return NSLocalizedString("Model could not be parsed", comment: "")
        case .configNotLoaded:
            return NSLocalizedString("Config could not be loaded", comment: "")
        }
    }
}
