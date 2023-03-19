//
//  StringUtils.swift
//

import UIKit

public final class StringUtils {
    static let shared = StringUtils()

    func merge(list: [String]) -> String {
        return list.joined(separator: " ")
    }
}
