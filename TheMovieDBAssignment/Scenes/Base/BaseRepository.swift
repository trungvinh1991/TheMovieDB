//
//  BaseRepository.swift
//  TheMovieDBAssignment
//
//  Created by Vinh Ly on 16/03/2021.
//

import Alamofire
import Combine

class BaseRepository: NSObject {
    final let TIME_OUT = 30.0
    static let defaultQueue: DispatchQueue = DispatchQueue(label: "com.service.queue", qos: .default)
    
    var sessionDelegate: SessionDelegate = SessionDelegate()
    var afSession: Session?
//    var serviceName: String = String(describing: self)
    
    override init() {
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TIME_OUT
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        self.afSession = Session(configuration: configuration,
                                 delegate: self.sessionDelegate,
                                 rootQueue: BaseRepository.defaultQueue,
                                 startRequestsImmediately: true,
                                 requestQueue: BaseRepository.defaultQueue,
                                 serializationQueue: BaseRepository.defaultQueue,
                                 interceptor: nil,
                                 serverTrustManager: nil,
                                 redirectHandler: nil,
                                 cachedResponseHandler: nil,
                                 eventMonitors: [])
    }
    
    func request<T: Decodable>(url: String,
                                  method: String,
                                  params: [String: Any],
                                  encoding: ParameterEncoding = URLEncoding.default,
                                  headers: [String: String]) -> AnyPublisher<T?, ErrorInfo> {
        return Future<T?, ErrorInfo> {[weak self] (promise) in
            let alamofireMethod = HTTPMethod(rawValue: method)
            self?.afSession?.request(url,
                                     method: alamofireMethod,
                                     parameters: params,
                                     encoding: URLEncoding.default,
                                     headers: HTTPHeaders(headers),
                                     interceptor: nil,
                                     requestModifier: nil)
                .response(completionHandler: { (response) in
                    guard let statusCode = response.response?.statusCode else {
                        var errorInfo = ErrorInfo()
                        errorInfo.statusCode = 999
                        errorInfo.errorDescription = "TechnicalProblem"
                        promise(.failure(errorInfo))
                        return
                    }
                    
                    switch response.result {
                    case .failure(let error):
                        var errorInfo = ErrorInfo()
                        if error.isResponseSerializationError { // empty response
                            let statusCode = response.response?.statusCode ?? 400
                            if statusCode < 400 {
                                errorInfo.statusCode = statusCode
                                errorInfo.errorDescription = error.errorDescription
                            }
                        } else {
                            errorInfo.statusCode = 999
                            errorInfo.errorDescription = "TechnicalProblem"
                        }
                        promise(.failure(errorInfo))
                    case .success(let data):
                        switch statusCode {
                        case 200, 201:
                            var obj: T?
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(dateFormatter)
                            if let data = data, let info = try? decoder.decode(T.self, from: data) {
                                obj = info
                            }
                            promise(.success(obj))
                        default:
                            var error = ErrorInfo()
                            error.statusCode = statusCode
                            error.errorDescription = "TechnicalProblem"
                            promise(.failure(error))
                        }
                    }
                })
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    open func cancel() {
        self.afSession?.session.getTasksWithCompletionHandler {
            dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}
