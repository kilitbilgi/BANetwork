//
//  BaseEndpoint.swift
//

import Foundation

public struct BaseEndpoint {
    enum Scheme: String {
        case http, https
    }

    // MARK: API host, Default https

    var scheme: Scheme = .https

    // MARK: Base Url of the API

    var host: String = ""

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

    // MARK: Generated URL for making request

    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = config.baseURL
        components.path = updatedPath
        components.queryItems = queryItems
        return components.url
    }

    // MARK: Auth header

    var authHeader: String?

    // MARK: Generated url request

    var urlRequest: URLRequest? {
        guard let url = url else {
            BaseLogger.error("Error: URL couldn't create")
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        if let header = authHeader {
            urlRequest.setValue(header, forHTTPHeaderField: "Authorization")
        }

        if let basicHeaders = headers {
            for header in basicHeaders {
                if let key = header.key as? String, let value = header.value as? String {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
        }

        if method != .get, let params = params {
            let httpBody = try? JSONSerialization.data(withJSONObject: params)
            urlRequest.httpBody = httpBody
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        return urlRequest
    }

    private var config: BAPlistModel {
        guard let model = BAPlistUtils.shared.config else {
            return BAPlistModel(baseURL: "", timeout: 0, isLogEnabled: false)
        }
        return model
    }

    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = config.timeout
        configuration.timeoutIntervalForResource = config.timeout

        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }

    public mutating func set(path: String) -> BaseEndpoint {
        self.path = path
        return self
    }

    public mutating func add(headers: [BAHeaderModel]) -> BaseEndpoint {
        self.headers = headers.dictionary as? NSMutableDictionary
        return self
    }

    public mutating func add(authHeader: String) -> BaseEndpoint {
        self.authHeader = authHeader
        return self
    }

    public mutating func add(method: BaseMethod) -> BaseEndpoint {
        self.method = method
        return self
    }

    public mutating func add(queryItems: [BAQueryModel]) -> BaseEndpoint {
        self.queryItems = QueryParamEncoder.encode(with: queryItems)
        return self
    }

    public mutating func add(params: [String: Any?]) -> BaseEndpoint {
        self.params = params
        return self
    }
}

private extension BaseEndpoint {
    var updatedPath: String {
        if path.starts(with: "/") {
            return path
        } else {
            return String(format: "/%@", path)
        }
    }
}
