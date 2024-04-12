//
//  APIServiceBase.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]
typealias ResponseHeader = [AnyHashable: Any]

protocol JSONData {
    init()
    static func equal(left: JSONData, right: JSONData) -> Bool
}

extension JSONDictionary: JSONData {
    static func equal(left: JSONData, right: JSONData) -> Bool {
        let equal = NSDictionary(dictionary: left as! JSONDictionary).isEqual(to: right as! JSONDictionary)
        return equal
    }
}

extension JSONArray: JSONData {
    static func equal(left: JSONData, right: JSONData) -> Bool {
        let leftArray = left as! JSONArray
        let rightArray = right as! JSONArray
        
        guard leftArray.count == rightArray.count else { return false }
        
        for i in 0..<leftArray.count {
            if !JSONDictionary.equal(left: leftArray[i], right: rightArray[i]) {
                return false
            }
        }
        
        return true
    }
}

class APIBase {
    
    var manager: Alamofire.Session
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        self.init(configuration: configuration)
    }
    
    init(configuration: URLSessionConfiguration) {
        manager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Decodable>(_ input: APIInputBase) -> Observable<T> {
        return request(input).map { $0.data }
    }
    
    func request<T: Decodable>(_ input: APIInputBase) -> Observable<APIResponse<T>> {
        let response: Observable<APIResponse<JSONDictionary>> = requestJSON(input)
        
        return response
            .map { apiResponse -> APIResponse<T> in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: apiResponse.data,
                                                              options: .prettyPrinted)
                    let t = try JSONDecoder().decode(T.self, from: jsonData)
                    return APIResponse(header: apiResponse.header, data: t)
                } catch {
                    throw APIInvalidResponseError()
                }
            }
    }
    
    func request<T: Codable>(_ input: APIInputBase) -> Observable<[T]> {
        return request(input).map { $0.data }
    }
    
    func request<T: Codable>(_ input: APIInputBase) -> Observable<APIResponse<[T]>> {
        let response: Observable<APIResponse<JSONArray>> = requestJSON(input)
        
        return response
            .map { apiResponse -> APIResponse<[T]> in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: apiResponse.data,
                                                              options: .prettyPrinted)

                    let items = try JSONDecoder().decode([T].self, from: jsonData)
                    return APIResponse(header: apiResponse.header,
                                       data: items)
                } catch {
                    throw APIInvalidResponseError()
                }
            }
    }
    
    func requestJSON<U: JSONData>(_ input: APIInputBase) -> Observable<APIResponse<U>> {
        let urlRequest = preprocess(input)
            .map { [unowned self] input -> DataRequest in
                    return self.manager.request(
                        input.urlString,
                        method: input.method,
                        parameters: input.parameters,
                        encoding: input.encoding,
                        headers: input.headers
                    )
            }
            .do(onNext: { (dataRequest) in
                dataRequest.cURLDescription { curl in
                    print(curl)
                }
            })
            .flatMapLatest { dataRequest in
                return dataRequest.rx.responseData()
            }
            .map { (dataResponse) -> APIResponse<U> in
                return try self.process(dataResponse)
            }
            .catch { [unowned self] error -> Observable<APIResponse<U>> in
                return try self.handleRequestError(error, input: input)
            }
        
        
        return urlRequest
    }
    
    func handleRequestError<U: JSONData>(_ error: Error,
                                              input: APIInputBase) throws -> Observable<APIResponse<U>> {
        throw error
    }
    
    func preprocess(_ input: APIInputBase) -> Observable<APIInputBase> {
        return Observable.just(input)
    }
    
    func process<U: JSONData>(_ dataResponse: (HTTPURLResponse, Data)) throws -> APIResponse<U> {
        let (urlResponse, data) = dataResponse
        let json: U? = (try? JSONSerialization.jsonObject(with: data, options: [])) as? U
        
        let error: Error
        let statusCode = urlResponse.statusCode
        
        switch statusCode {
        case 200..<300:
            return APIResponse(header: urlResponse.allHeaderFields, data: json ?? U.init())
        default:
            error = handleResponseError(response: urlResponse, data: data, json: json)
        }
        throw error
    }
    
    func handleResponseError<U: JSONData>(response: HTTPURLResponse, data: Data, json: U?) -> Error {
        if let jsonDictionary = json as? JSONDictionary {
            return handleResponseError(response: response, data: data, json: jsonDictionary)
        } else if let jsonArray = json as? JSONArray {
            return handleResponseError(response: response, data: data, json: jsonArray)
        }
        
        return handleResponseUnknownError(response: response, data: data)
    }
    
    func handleResponseError(response: HTTPURLResponse, data: Data, json: JSONDictionary?) -> Error {
        return APIUnknownError(statusCode: response.statusCode)
    }
    
    func handleResponseError(response: HTTPURLResponse, data: Data, json: JSONArray?) -> Error {
        return APIUnknownError(statusCode: response.statusCode)
    }
    
    func handleResponseUnknownError(response: HTTPURLResponse, data: Data) -> Error {
        return APIUnknownError(statusCode: response.statusCode)
    }
}
