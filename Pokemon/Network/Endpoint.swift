//
//  Endpoint.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

public enum HTTPMethodType: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

public protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParamaters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParamatersEncodable: Encodable? { get }
    var bodyParamaters: [String: Any] { get }
    var formData: Bool { get }
    var imageData: (String, [Data]) { get }
    var bodyEncoding: BodyEncoding { get }

    func urlRequest(with networkConfig: ApiDataNetworkConfig) throws -> URLRequest
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {

    func url(with config: ApiDataNetworkConfig) throws -> URL {

        let baseURL = config.baseURL.absoluteString.last != "/" && !path.hasPrefix("/")
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)

        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        if let query = urlComponents.queryItems {
            urlQueryItems.insert(contentsOf: query, at: 0)
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }

    public func urlRequest(with config: ApiDataNetworkConfig) throws -> URLRequest {

        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers

        headerParamaters.forEach { allHeaders.updateValue($1, forKey: $0) }

        let bodyParamaters = try bodyParamatersEncodable?.toDictionary() ?? self.bodyParamaters
        if self.formData {
            let boundary = "Boundary----\(UUID().uuidString)"
            allHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
            let httpBody = NSMutableData()
            for (key, value) in bodyParamaters {
                httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
            }
            print(String(data: httpBody as Data, encoding: .utf8) ?? "")
            for value in imageData.1 {
                httpBody.append(convertFileData(
                                    fieldName: imageData.0,
                                    fileName: "imagename.png",
                                    mimeType: "image/png",
                                    fileData: value,
                                    using: boundary))
            }
            httpBody.appendString("--\(boundary)--")
            urlRequest.httpBody = httpBody as Data
        }
        if let bodyParamatersEncodable = bodyParamatersEncodable {
            urlRequest.httpBody = bodyParamatersEncodable.toJSON()?.data(using: .utf8)
        } else if !bodyParamaters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParamaters: bodyParamaters, bodyEncoding: bodyEncoding)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }

    private func encodeBody(bodyParamaters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParamaters)
        case .stringEncodingAscii:
            return bodyParamaters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }

    //MARK: Multipart form data
    private func convertFormField(named name: String, value: Any, using boundary: String) -> String {
        var val: String?
        if let stringValue = value as? String {
            val = stringValue
        }
        if let intValue = value as? Int {
            val = String(intValue)
        }
        guard let v = val else {
            fatalError()
        }
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(v)\r\n"

        return fieldString

    }

    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()

        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")

        return data as Data
    }
}

public class Endpoint: Requestable {

    public var path: String
    public var isFullPath: Bool
    public var method: HTTPMethodType
    public var headerParamaters: [String: String]
    public var queryParametersEncodable: Encodable? = nil
    public var queryParameters: [String: Any]
    public var bodyParamatersEncodable: Encodable? = nil
    public var bodyParamaters: [String: Any]
    public var formData: Bool
    public var imageData: (String, [Data])
    public var bodyEncoding: BodyEncoding

    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         headerParamaters: [String: String] = [:],
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String: Any] = [:],
         bodyParamatersEncodable: Encodable? = nil,
         bodyParamaters: [String: Any] = [:],
         formData: Bool = false,
         imageData: (String, [Data]) = ("", []),
         bodyEncoding: BodyEncoding = .jsonSerializationData) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParamaters = headerParamaters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParamatersEncodable = bodyParamatersEncodable
        self.bodyParamaters = bodyParamaters
        self.formData = formData
        self.imageData = imageData
        self.bodyEncoding = bodyEncoding
    }
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String: Any]
    }
    
    func toJSON() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!

            return jsonString
        } catch {
            return nil
        }
    }
}

private extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

