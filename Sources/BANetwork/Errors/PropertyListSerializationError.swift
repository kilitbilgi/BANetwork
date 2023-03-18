//
//  PropertyListSerializationError.swift
//  
//
//  Created by Burak Colak on 18.03.2023.
//

import Foundation

public enum PropertyListSerializationError: Error {
    case fileNotFound
    case dataNotAvailable
    case fileNotParsed
    case modelNotParsed
}
