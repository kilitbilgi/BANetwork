//
//  BAEndpoint.swift
//  
//
//  Created by burak on 19.03.2023.
//

import UIKit

public final class BAEndpoint {
    public init() {}
    // MARK: API host, Default https
    var scheme: BaseScheme = .https

    // MARK: The path for api access
    var path = ""

    // MARK: Url Parameters
    var queryItems: [URLQueryItem]?

    // MARK: Request parameters
    var params: [String: Any?]?

    // MARK: Headers
    var headers: NSMutableDictionary?

    // MARK: Default method: GET
    var method: BaseMethod = .get

    // MARK: Auth header
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
