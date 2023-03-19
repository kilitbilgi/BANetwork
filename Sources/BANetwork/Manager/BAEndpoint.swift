//
//  BAEndpoint.swift
//

import UIKit

public final class BAEndpoint {
    public init() {}

    var scheme: BaseScheme = .https
    var path = ""
    var queryItems: [URLQueryItem]?
    var params: [String: Any?]?
    var headers: NSMutableDictionary?
    var method: BaseMethod = .get
    var authHeader: String?

    public func set(path: String) -> BAEndpoint {
        self.path = path
        return self
    }

    public func add(headers: [BAHeaderModel]) -> BAEndpoint {
        self.headers = headers.dictionary as? NSMutableDictionary
        return self
    }

    public func add(authHeader: String) -> BAEndpoint {
        self.authHeader = authHeader
        return self
    }

    public func add(method: BaseMethod) -> BAEndpoint {
        self.method = method
        return self
    }

    public func add(queryItems: [BAQueryModel]) -> BAEndpoint {
        self.queryItems = QueryParamEncoder.encode(with: queryItems)
        return self
    }

    public func add(params: [String: Any?]) -> BAEndpoint {
        self.params = params
        return self
    }

    public func build() -> BaseEndpoint {
        return BaseEndpoint(scheme: scheme, path: path, queryItems: queryItems, params: params, headers: headers, method: method, authHeader: authHeader)
    }
}
