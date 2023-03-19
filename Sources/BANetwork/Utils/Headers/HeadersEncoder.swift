//
//  HeadersEncoder.swift
//

import Foundation

final class HeadersEncoder {
    static func encode(with list: [BAHeaderModel]) -> NSMutableDictionary {
        return list.reduce(into: NSMutableDictionary()) {
            $0[$1.field] = $1.value
        }
    }
}
