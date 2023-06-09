//
//  BAEndpoint.swift
//

import UIKit

public final class BAEndpoint {
    public init() {}

    var host: String?
    var scheme: BaseScheme = .https
    var path = ""
    var queryItems: [URLQueryItem]?
    var queryItemsModel: [BAQueryModel]?
    var params: [String: Any?]?
    var paramsModel: [BABodyModel]?
    var headers: NSMutableDictionary?
    var headersModel: [BAHeaderModel]?
    var method: BaseMethod = .get
    var authHeader: String?

    public func set(host: String) -> BAEndpoint {
        self.host = host
        return self
    }

    public func set(path: String) -> BAEndpoint {
        self.path = path
        return self
    }

    public func set(path: BAPathModel) -> BAEndpoint {
        let pathQuery = [path.path, path.value].joined(separator: "/")
        self.path = pathQuery
        return self
    }

    public func set(method: BaseMethod) -> BAEndpoint {
        self.method = method
        return self
    }

    public func add(header: BAHeaderModel) -> BAEndpoint {
        var headerList = [BAHeaderModel]()
        if let list = headersModel, list.count > 0 {
            headerList = list
            headerList.append(header)
        } else {
            headerList.append(header)
        }

        headersModel = headerList
        headers = HeadersEncoder.encode(with: headerList)
        return self
    }

    public func add(headers: [BAHeaderModel]) -> BAEndpoint {
        self.headers = HeadersEncoder.encode(with: headers)
        return self
    }

    public func add(authHeader: String) -> BAEndpoint {
        self.authHeader = authHeader
        return self
    }

    public func add(queryItem: BAQueryModel) -> BAEndpoint {
        var queryList = [BAQueryModel]()
        if let list = queryItemsModel, list.count > 0 {
            queryList = list
            queryList.append(queryItem)
        } else {
            queryList.append(queryItem)
        }

        queryItemsModel = queryList
        queryItems = QueryParamEncoder.encode(with: queryList)
        return self
    }

    public func add(queryItems: [BAQueryModel]) -> BAEndpoint {
        self.queryItems = QueryParamEncoder.encode(with: queryItems)
        return self
    }

    public func add(param: BABodyModel) -> BAEndpoint {
        var paramList = [BABodyModel]()
        if let list = paramsModel, list.count > 0 {
            paramList = list
            paramList.append(param)
        } else {
            paramList.append(param)
        }

        paramsModel = paramList
        params = BodyEncoder.encode(with: paramList)
        return self
    }

    public func add(params: [BABodyModel]) -> BAEndpoint {
        self.params = BodyEncoder.encode(with: params)
        return self
    }

    public func build() -> BaseEndpoint {
        return BaseEndpoint(host: host, scheme: scheme, path: path, queryItems: queryItems, params: params, headers: headers, method: method, authHeader: authHeader)
    }
}
