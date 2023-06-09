//
//  BaseLogger.swift
//

import Foundation
import os.log

class BaseLogger {
    /// shared instance
    static var shared = BaseLogger()

    private init() {}

    /// is BaseLoggerging enable
    var isEnabled: Bool {
        return BAPlistUtils.shared.config?.isLogEnabled ?? false
    }

    /// BaseLogger for success. Will add ✅ emoji to see better
    ///
    /// - Parameter message: BaseLoggerging message
    static func info(_ message: String) {
        guard BaseLogger.shared.isEnabled else { return }
        BaseLogger.shared.debug(type: "✅", message: message)
    }

    /// BaseLogger for warning. Will add ⚠️ emoji to see better
    ///
    /// - Parameter message: BaseLoggerging message
    static func warning(_ message: String) {
        guard BaseLogger.shared.isEnabled else { return }
        BaseLogger.shared.debug(type: "⚠️", message: message)
    }

    /// BaseLogger for error. Will add ❌ emoji to see better
    ///
    /// - Parameter message: BaseLoggerging message
    static func error(_ message: String) {
        guard BaseLogger.shared.isEnabled else { return }
        BaseLogger.shared.debug(type: "❌", message: message)
    }

    private func debug(type: Any?, message: String) {
        guard BaseLogger.shared.isEnabled else { return }
        DispatchQueue.main.async {
            os_log("%@", type: .debug, "\(type ?? "") -> \(message)")
        }
    }
}
