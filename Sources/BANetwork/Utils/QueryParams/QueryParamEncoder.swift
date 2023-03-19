//
//  QueryParamEncoder.swift
//

import Foundation

final class QueryParamEncoder {
    static func encode(with list: [BAQueryList]) -> [URLQueryItem] {
        return list.map { URLQueryItem(name: $0.name, value: $0.value) }
    }
}
