//
//  BANetwork.swift
//

import Foundation

public class BANetwork {
    open var errorMessage = "An error occurred."
    open var responseInfoMessage = "RESPONSE:"
    open var responseNullMessage = "Response null"
    open var dataNullMessage = "Data null"
    open var dataParseSuccessMessage = "Data parsed successfully"
    open var dataParseErrorMessage = "Data parsing error : %@"
    open var urlRequestErrorMessage = "URL Request Error"
    open var httpStatusError = "HTTP Status error"
    open var httpURLMessage = "HTTP URL:"
    open var httpAuthHeadersMessage = "HTTP AUTH HEADERS:"
    open var httpHeadersMessage = "HTTP HEADERS:"
    open var httpQueryItemsMessage = "HTTP QUERYITEMS:"
    open var httpBodyMessage = "HTTP BODY:"
    open var httpRequestType = "HTTP Request TYPE:"

    public init() {}

    public func baseRequest(to endpoint: BaseEndpoint) -> URLRequest? {
        guard let urlRequest = endpoint.urlRequest else {
            BaseLogger.error(urlRequestErrorMessage)
            return nil
        }

        let info = StringUtils.shared.merge(list: [
            httpRequestType,
            endpoint.method.rawValue,
        ])
        BaseLogger.info(info)

        if let url = endpoint.url {
            let info = StringUtils.shared.merge(list: [
                httpURLMessage,
                "\(url)",
            ])
            BaseLogger.info(info)
        }

        if let authHeader = endpoint.authHeader, authHeader.count > 0 {
            let info = StringUtils.shared.merge(list: [
                httpAuthHeadersMessage,
                "\(authHeader)",
            ])
            BaseLogger.info(info)
        }

        if let headers = endpoint.headers, headers.count > 0 {
            let info = StringUtils.shared.merge(list: [
                httpHeadersMessage,
                "\(headers)",
            ])
            BaseLogger.info(info)
        }

        if let queryItems = endpoint.queryItems, queryItems.count > 0 {
            let info = StringUtils.shared.merge(list: [
                httpQueryItemsMessage,
                "\(queryItems)",
            ])
            BaseLogger.info(info)
        }

        if let data = urlRequest.httpBody {
            let info = StringUtils.shared.merge(list: [
                httpBodyMessage,
                String(data: data, encoding: .utf8) ?? "",
            ])
            BaseLogger.info(info)
        }

        return urlRequest
    }

    public func request<T: Decodable>(to endpoint: BaseEndpoint, completion: @escaping (BaseResult<T, Error>) -> Void) {
        guard let urlRequest = baseRequest(to: endpoint) else {
            BaseLogger.error(urlRequestErrorMessage)
            return
        }

        let dataTask = endpoint.session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else {
                return
            }

            guard error == nil else {
                let message = StringUtils.shared.merge(list: [
                    self.errorMessage,
                    error?.localizedDescription ?? ""
                ])
                BaseLogger.error(message)
                completion(.failure(BaseNetworkError(message: self.errorMessage, log: error?.localizedDescription, endpoint: endpoint)))
                return
            }
            guard response != nil else {
                let message = StringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.responseNullMessage
                ])
                BaseLogger.error(message)
                completion(.failure(BaseNetworkError(message: self.errorMessage, log: self.responseNullMessage, endpoint: endpoint)))
                return
            }
            guard let data = data else {
                let message = StringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.dataNullMessage
                ])
                BaseLogger.error(message)
                completion(.failure(BaseNetworkError(message: self.errorMessage, log: self.dataNullMessage, endpoint: endpoint)))
                return
            }

            if error?.isConnectivityError ?? false {
                let message = StringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.dataNullMessage
                ])
                BaseLogger.error(message)
                completion(.failure(BaseNetworkError(message: self.errorMessage, log: self.dataNullMessage, endpoint: endpoint)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                let message = StringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.httpStatusError
                ])
                BaseLogger.error(message)
                completion(.failure(BaseNetworkError(message: self.errorMessage, log: self.httpStatusError, endpoint: endpoint)))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)

                let info = StringUtils.shared.merge(list: [
                    self.responseInfoMessage,
                    String(data: data, encoding: .utf8) ?? "",
                ])
                BaseLogger.info(info)
                completion(.success(responseObject))
            } catch let e {
                let errorMessage = String(format: self.dataParseErrorMessage, e.localizedDescription)
                BaseLogger.warning(errorMessage)
                completion(.failure(BaseNetworkError(message: self.errorMessage, log: errorMessage, endpoint: endpoint)))
            }
        }
        dataTask.resume()
    }

    public func request(to endpoint: BaseEndpoint, completion: GenericCallbacks.InfoCallback) {
        guard let urlRequest = baseRequest(to: endpoint) else {
            BaseLogger.error(urlRequestErrorMessage)
            return
        }

        let dataTask = endpoint.session.dataTask(with: urlRequest) { [weak self] _, response, error in
            guard let self = self else {
                return
            }

            guard error == nil else {
                completion?(false, BaseNetworkError(message: self.errorMessage, log: error?.localizedDescription, endpoint: endpoint))
                return
            }
            guard response != nil else {
                completion?(false, BaseNetworkError(message: self.errorMessage, log: self.responseNullMessage, endpoint: endpoint))
                return
            }

            if error?.isConnectivityError ?? false {
                completion?(false, BaseNetworkError(message: self.errorMessage, log: self.dataNullMessage, endpoint: endpoint))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                completion?(false, BaseNetworkError(message: self.errorMessage, log: self.httpStatusError, endpoint: endpoint))
                return
            }

            BaseLogger.info(self.dataParseSuccessMessage)
            completion?(true, nil)
        }
        dataTask.resume()
    }
}
