//
//  QueryParamEncoder.swift
//  
//
//  Created by Burak Colak on 18.03.2023.
//

import Foundation

final class QueryParamEncoder {
    static func encode(with list: [QueryList]) -> [URLQueryItem] {
        return list.map { URLQueryItem(name: $0.name, value: $0.value) }
    }
}
