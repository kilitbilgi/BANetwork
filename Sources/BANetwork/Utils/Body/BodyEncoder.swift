//
//  BodyEncoder.swift
//

import Foundation

final class BodyEncoder {
    static func encode(with list: [BABodyModel]) -> [String: Any?] {
        return list.reduce(into: [String: Any?]()) {
            $0[$1.key] = $1.value
        }
    }
}
