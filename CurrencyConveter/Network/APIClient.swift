//
//  APICleint.swift
//  CurrencyConveter
//
//  Created by Eissa on 12/14/17.
//  Copyright © 2017 Asgatech. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import RxSwift

typealias ErrorHandler = (_ error: Error) -> Void
typealias SuccessHandler<T> = (_ response: T) -> Void
typealias ProgressHandler = (_ fractionCompleted: Double) -> Void
typealias DownloadHandler = (_ fileUrl: URL?) -> Void

final class APIClient {
    // MARK: - Manager
    static private let Manager = { () -> SessionManager in
        return Alamofire.SessionManager.default
    }()
    static func cancelRequests(ofTypes types: RequestType...) {
        Manager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            if types.contains(.session) {
                sessionDataTask.forEach { $0.cancel() }
            }
            if types.contains(.upload) {
                uploadData.forEach { $0.cancel() }
            }
            if types.contains(.download) {
                downloadData.forEach { $0.cancel() }
            }
        }
    }
}
// MARK: - Session
extension APIClient {
    private static func startRequest(request: Request, sucess: @escaping SuccessHandler<DynamicResponse>, error: @escaping ErrorHandler) {
        print(request)
        var urlRequest = URLRequest(url: URL(string: request.fullPath)!)
        urlRequest.httpMethod = request.method.rawValue
        for item in request.fullHeaders{
            urlRequest.setValue(item.value, forHTTPHeaderField: item.key)
        }
        if let body = request.body {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: body)
        }
        Manager.request(urlRequest).responseJSON { response in
            mapDataResponse(response: response, nested: request.selection, sucess: sucess, error: error)
            }
    }
    static func excute<T>(request: Request, sucess: @escaping SuccessHandler<T>, error: @escaping ErrorHandler) {
        startRequest(request: request, sucess: { response in
            mapResponse(response: response, model: T.self, sucess: sucess, error: error)
        }, error: error)
    }
    static func excute<T>(request: Request, sucess: @escaping SuccessHandler<T>, error: @escaping ErrorHandler) where T : BaseMappable {
        startRequest(request: request, sucess: { response in
            mapResponse(response: response, model: T.self, sucess: sucess, error: error)
        }, error: error)
    }
    static func excute<T: Sequence>(request: Request, sucess: @escaping SuccessHandler<T>, error: @escaping ErrorHandler) where T.Element : BaseMappable {
        startRequest(request: request, sucess: { response in
            mapResponse(response: response, model: T.self, m: T.Element.self, sucess: sucess, error: error)
        }, error: error)
    }
    
}
// MARK: - Upload
extension APIClient {
     static private func upload(files: [MPfile] , request: Request, sucess: @escaping SuccessHandler<DynamicResponse>, progress: @escaping ProgressHandler, error: @escaping ErrorHandler) {
        print(request)
        Manager.upload(multipartFormData:{ multipartFormData in
            for file in files {
                multipartFormData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.memType)
            }
            if let dic = request.body  as? [String: Any] {
                for (key, value) in dic {
                    multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
                }
            }}, to: request.fullPath,
                method: request.method,
                headers: request.fullHeaders,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            mapDataResponse(response: response, nested: request.selection, sucess: sucess, error: error)
                        }
                        upload.uploadProgress(closure: { (prog) in
                            progress(prog.fractionCompleted)
                        })
                    case .failure(let encodingError):
                        error(encodingError)
                    }
        })
    }
    static func upload<T>(files: [MPfile] , request: Request, sucess: @escaping SuccessHandler<T>, progress: @escaping ProgressHandler, error: @escaping ErrorHandler) {
        upload(files: files, request: request, sucess: { response in
            mapResponse(response: response, model: T.self, sucess: sucess, error: error)
        }, progress: progress, error: error)
    }
    static func upload<T>(files: [MPfile] , request: Request, sucess: @escaping SuccessHandler<T>, progress: @escaping ProgressHandler, error: @escaping ErrorHandler) where T: Mappable{
        upload(files: files, request: request, sucess: { response in
            mapResponse(response: response, model: T.self, sucess: sucess, error: error)
        }, progress: progress, error: error)
    }
    static func upload<T: Sequence>(files: [MPfile] , request: Request, sucess: @escaping SuccessHandler<T>, progress: @escaping ProgressHandler, error: @escaping ErrorHandler) where T.Element: Mappable {
        upload(files: files, request: request, sucess: { response in
            mapResponse(response: response, model: T.self, sucess: sucess, error: error)
        }, progress: progress, error: error)
    }
    
}
// MARK: - Download
extension APIClient {
    static func downloadFile(withUrl url: String, success: @escaping DownloadHandler, progress: @escaping ProgressHandler, error: @escaping ErrorHandler) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Manager.download(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (prog) in
                progress(prog.fractionCompleted)
            }).response(completionHandler: { (DefaultDownloadResponse) in
                if let downloadError = DefaultDownloadResponse.error {
                    error(downloadError)
                } else {
                    success(DefaultDownloadResponse.destinationURL)
                }
            })
    }
}
// MARK: - RX Session
extension APIClient {
    static func excute<T>(request: Request) -> Single<T>  {
        return Single<T>.create(subscribe: { single  in
            APIClient.excute(request: request, sucess: { (response) in
                single(.success(response))
            }) { (error) in
                single(.error(error))
            }
            return Disposables.create()
        })
    }
    static func excute<T>(request: Request) -> Single<T> where T : BaseMappable   {
        return Single<T>.create(subscribe: { single  in
            APIClient.excute(request: request, sucess: { (response) in
                single(.success(response))
            }) { (error) in
                single(.error(error))
            }
            return Disposables.create()
        })
    }
    static func excute<T: Sequence>(request: Request) -> Single<T> where T.Element : BaseMappable   {
        return Single<T>.create(subscribe: { single  in
            APIClient.excute(request: request, sucess: { (response) in
                single(.success(response))
            }) { (error) in
                single(.error(error))
            }
            return Disposables.create()
        })
    }
}
// MARK: - Data Mapping
extension APIClient {
    static private func mapDataResponse(response: DataResponse<Any>, nested: [Nested], sucess: @escaping SuccessHandler<DynamicResponse>, error: @escaping ErrorHandler)  {
        if let responseError = response.error {
            error(responseError)
            return
        }
        
        switch response.response?.statusCode {
        case 200? :
            let dynamicResponse = DynamicResponse(response.value)
            
            if let bool = dynamicResponse.success.object as? Bool, bool {
                sucess(dynamicResponse[nested])
            } else  {
                let _error = NSError.init(domain: dynamicResponse.error.info.object as? String ?? "",
                                         code: dynamicResponse.code.object as? Int ?? 0,
                                         userInfo: nil)
                error(_error)
            }
    
        case let code?:
            error(NSError.init(domain: "Error \(code)", code: code, userInfo: [:]))
        default:
            break
        }
    }
    
    static private func mapResponse<T>(response : DynamicResponse ,model : T.Type, sucess: @escaping SuccessHandler<T>, error: @escaping ErrorHandler) {
        if let value = response.object as? T {
            sucess(value)
            return
        }
        error(NSError.init("Can not cast \(type(of: response.object)) to \(type(of: model))"))
    }
    
    static private func mapResponse<T>(response : DynamicResponse ,model : T.Type, sucess: @escaping SuccessHandler<T>, error: @escaping ErrorHandler) where T : BaseMappable {
        if let dictionary = response.object as? [String: Any],
            let model = Mapper<T>().map(JSON: dictionary)  {
            sucess(model)
            return
        }
        error(NSError.init("Can not cast \(type(of: response.object)) to \(type(of: model))"))
    }
    static private func mapResponse<T: Sequence, M: BaseMappable>(response : DynamicResponse ,model :T.Type, m: M.Type ,sucess: @escaping SuccessHandler<T>, error: @escaping ErrorHandler) where T.Element : BaseMappable {
        if let array = response.object as? [[String: Any]],
            let modelArray = Mapper<M>().mapArray(JSONArray: array) as? T {
            sucess(modelArray)
            return
        }
        error(NSError.init("Can not cast \(type(of: response.object)) to \(type(of: model))"))
    }
}
