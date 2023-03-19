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

    public init() {}

    public func baseRequest(to endpoint: BaseEndpoint) -> URLRequest? {
        guard let urlRequest = endpoint.urlRequest else {
            BaseLogger.error(urlRequestErrorMessage)
            return nil
        }

        if let data = endpoint.url {
            BaseLogger.info(httpURLMessage + "\(data)")
        }

        if let authHeader = endpoint.authHeader, authHeader.count > 0 {
            BaseLogger.info(httpAuthHeadersMessage + "\(authHeader)")
        }

        if let data = endpoint.headers, data.count > 0 {
            BaseLogger.info(httpHeadersMessage + "\(data)")
        }

        if let data = endpoint.queryItems, data.count > 0 {
            BaseLogger.info(httpQueryItemsMessage + "\(data)")
        }

        if let data = urlRequest.httpBody {
            BaseLogger.info(httpBodyMessage + String(decoding: data, as: UTF8.self))
        }

        return urlRequest
    }

    public func request<T: Decodable>(to endpoint: BaseEndpoint, completion: @escaping (BaseResult<T, Error>) -> Void) {
        guard let urlRequest = baseRequest(to: endpoint) else {
            BaseLogger.error(urlRequestErrorMessage)
            return
        }

        let dataTask = endpoint.session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(BaseNetworkError(message: self?.errorMessage, log: error?.localizedDescription, endpoint: endpoint)))
                return
            }
            guard response != nil else {
                completion(.failure(BaseNetworkError(message: self?.errorMessage, log: self?.responseNullMessage, endpoint: endpoint)))
                return
            }
            guard let data = data else {
                completion(.failure(BaseNetworkError(message: self?.errorMessage, log: self?.dataNullMessage, endpoint: endpoint)))
                return
            }

            if error?.isConnectivityError ?? false {
                completion(.failure(BaseNetworkError(message: self?.errorMessage, log: self?.dataNullMessage, endpoint: endpoint)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                completion(.failure(BaseNetworkError(message: self?.errorMessage, log: self?.httpStatusError, endpoint: endpoint)))
                return
            }

            BaseLogger.info(self?.responseInfoMessage ?? "" + String(decoding: data, as: UTF8.self))

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                BaseLogger.info(self?.dataParseSuccessMessage)
                completion(.success(responseObject))
            } catch let e {
                let errorMessage = String(format: self?.dataParseErrorMessage ?? "", e.localizedDescription)
                BaseLogger.warning(errorMessage)
                completion(.failure(BaseNetworkError(message: self?.errorMessage, log: errorMessage, endpoint: endpoint)))
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
            guard error == nil else {
                completion?(false, BaseNetworkError(message: self?.errorMessage, log: error?.localizedDescription, endpoint: endpoint))
                return
            }
            guard response != nil else {
                completion?(false, BaseNetworkError(message: self?.errorMessage, log: self?.responseNullMessage, endpoint: endpoint))
                return
            }

            if error?.isConnectivityError ?? false {
                completion?(false, BaseNetworkError(message: self?.errorMessage, log: self?.dataNullMessage, endpoint: endpoint))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                completion?(false, BaseNetworkError(message: self?.errorMessage, log: self?.httpStatusError, endpoint: endpoint))
                return
            }

            BaseLogger.info(self?.dataParseSuccessMessage)
            completion?(true, nil)
        }
        dataTask.resume()
    }
}
