//
//  Connection.swift
//  Life Coach
//
//  Created by Pinkesh Gajjar on 11/04/17.
//  Copyright © 2018 Life Coach. All rights reserved.
//

import Alamofire

protocol ConnectionProtocol {
    func Success(TAG: String, json: String, data: Data?)
    func Failure(TAG: String, error: String)
    func NoConnection(TAG: String)
}

protocol ProgressProtocol {
    func Progress(TAG: String, percent: Float)
}


class Connection {
    
    private var TAG: String!
    private var view: UIView!
    
    private var myProtocol : ConnectionProtocol!
    private var progressProtocol : ProgressProtocol?
    
    private var baseUrl = Constants.web_url
    private var refreshControl: UIRefreshControl?
    private var isLoading: Bool = false
    private var dataRequest : DataRequest!
    private var uploadRequest : UploadRequest!
    private var hideLoader : Bool = false
    private var encoding : ParameterEncoding = URLEncoding.default
    
    required init(TAG: String, view: UIView, myProtocol: ConnectionProtocol) {
        self.TAG = TAG
        self.view = view
        self.myProtocol = myProtocol
    }
    
    func setProgress(progressProtocol: ProgressProtocol?) {
        self.progressProtocol = progressProtocol
    }
    
    func jsonEncoding(enable : Bool) {
        if enable {
            self.encoding = JSONEncoding.default
        } else {
            self.encoding = URLEncoding.default
        }
    }
    
    func setRefreshControl(refreshControl: UIRefreshControl?){
        self.refreshControl =  refreshControl
    }
    
    func setBaseUrl(baseUrl: String){
        self.baseUrl =  baseUrl
    }
    
    func hideLoader(hide : Bool) {
        self.hideLoader = hide
    }
    
    func requestPost(connectionUrl: String, headers: HTTPHeaders = HTTPHeaders.init(), params: Parameters) {
        
        Utils.CheckLog(tag: self.TAG, value: "URL: " + connectionUrl)
        Utils.CheckLog(tag: self.TAG, value: "Headers: \(headers)")
        Utils.CheckLog(tag: self.TAG, value: "Parameters: \(params)")
        
        //self.loading(status: true)
        print("From requestPost : ", self.baseUrl + connectionUrl)
        
//        let requestTemp = AF. //AF.request("https://swapi.dev/api/films")
//            // 2
//        requestTemp.responseJSON { (data) in
//          print(data)
//        }
//
        self.dataRequest = AF.request(self.baseUrl + connectionUrl, method: HTTPMethod.post, parameters: params, encoding: self.encoding, headers: headers).responseString {
            response in
            
            //self.loading(status: false)
            
            switch response.result {
            case let .success(value):
                print(value)
                Utils.CheckLog(tag: self.TAG, value: "RequestPost Json: " + value)
                self.myProtocol.Success(TAG: self.TAG, json: value, data: nil)
                break
            case let .failure(error):
                print(error)
                Utils.CheckLog(tag: self.TAG, value: "Error: " + error.localizedDescription)
                self.myProtocol.Failure(TAG: self.TAG, error: error.localizedDescription)
                break
            }
            
//            switch response.result {
//            case .success:
//                if let json = response.result {
//                    Utils.CheckLog(tag: self.TAG, value: "Json: " + json)
//                    self.myProtocol.Success(TAG: self.TAG, json: json, data: nil)
//                }
//                break
//            case .failure(let error):
//                Utils.CheckLog(tag: self.TAG, value: "Error: " + error.localizedDescription)
//                self.myProtocol.Failure(TAG: self.TAG, error: error.localizedDescription)
//                break
//            }
        }
    }

    func requestGet(connectionUrl: String, headers: HTTPHeaders = HTTPHeaders.init(), params: Parameters) {
        
        Utils.CheckLog(tag: self.TAG, value: "URL: " + connectionUrl)
        Utils.CheckLog(tag: self.TAG, value: "Headers: \(headers)")
        Utils.CheckLog(tag: self.TAG, value: "Parameters: \(params)")
        
        self.loading(status: true)
        
        self.dataRequest = AF.request(self.baseUrl + connectionUrl, method: HTTPMethod.get, parameters: params, encoding: self.encoding, headers: headers).responseString {
            response in
            
            self.loading(status: false)
            
            switch response.result {
            case let .success(value):
                print(value)
                Utils.CheckLog(tag: self.TAG, value: "Json: " + value)
                self.myProtocol.Success(TAG: self.TAG, json: value, data: nil)
                break
            case let .failure(error):
                print(error)
                Utils.CheckLog(tag: self.TAG, value: "Error: " + error.localizedDescription)
                self.myProtocol.Failure(TAG: self.TAG, error: error.localizedDescription)
                break
            }
            
//            switch response.result {
//            case .success:
//                if let json = response.result.value {
//                    Utils.CheckLog(tag: self.TAG, value: "Json: " + json)
//                    self.myProtocol.Success(TAG: self.TAG, json: json, data: nil)
//                }
//                break
//            case .failure(let error):
//                Utils.CheckLog(tag: self.TAG, value: "Error: " + error.localizedDescription)
//                self.myProtocol.Failure(TAG: self.TAG, error: error.localizedDescription)
//                break
//            }
        }
    }
    
    /*func requestUpload(connectionUrl: String, imageName: String, imageType: String, params: Parameters, files: Parameters) {
        
        Utils.CheckLog(tag: self.TAG, value: "URL: " + connectionUrl)
        Utils.CheckLog(tag: self.TAG, value: "Parameters: \(params)")
        
        print("From Url : ",self.baseUrl + connectionUrl)
        
        self.loading(status: true)
        
        AF.upload(multipartFormData: {
            multipartFormData in
            
            for (paramKey, paramValue) in params {
                multipartFormData.append((paramValue as! String).data(using: .utf8, allowLossyConversion: false)!, withName: paramKey)
            }
            for (imageKey, imageValue) in files {
                
                if let image = imageValue as? String, let imageUrl = URL.init(string: image) {
                    Utils.CheckLog(tag: "upload", value: "string, \(imageKey)")
                    multipartFormData.append(imageUrl, withName: imageKey)
                    //multipartFormData.append(imageUrl, withName: imageKey, mimeType: "image/jpg")
                } else if let imageUrl = imageValue as? URL {
                    Utils.CheckLog(tag: "upload", value: "url, \(imageKey)")
                    multipartFormData.append(imageUrl, withName: imageKey)
                } else if let imageData = imageValue as? Data {
                    Utils.CheckLog(tag: "upload", value: "data, \(imageKey)")
                    //multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
                    if imageType == "JPG" {
                        let fileName = imageKey + ".jpg"
                        multipartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/jpg")
                    } else if imageType == "PNG" {
                        let fileName = imageKey + ".png"
                        multipartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/png")
                    } else {
                        let fileName = imageKey + ".png"
                        multipartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/png")
                    }
                    continue
                }
            }
            
        },to: self.baseUrl + connectionUrl , encodingCompletion: {
            encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                self.uploadRequest = upload
                upload.uploadProgress {
                    progress in
                    
                    let total = Float(progress.totalUnitCount)
                    Utils.CheckLog(tag: self.TAG, value: "Total: \(total)")
                    
                    let progress = Float(progress.completedUnitCount)
                    Utils.CheckLog(tag: self.TAG, value: "Progress: \(progress)")
                    
                    let percent = progress / total
                    print("From requestUpload")
                    Utils.CheckLog(tag: self.TAG, value: "Percent: \(percent)")
                    print("From requestUpload 1")
                    self.progressProtocol?.Progress(TAG: self.TAG, percent: percent)
                    print("From requestUpload 2")
                }
                upload.responseString(completionHandler: {
                    response in
                    
                    self.loading(status: false)
                    
                    if let json = response.result.value {
                        Utils.CheckLog(tag: self.TAG, value: "Json: " + json)
                        self.myProtocol.Success(TAG: self.TAG, json: json, data: nil)
                    }
                })
                
                break
            case .failure(let error):
                self.loading(status: false)
                
                Utils.CheckLog(tag: self.TAG, value: "Error: " + error.localizedDescription)
                self.myProtocol.Failure(TAG: self.TAG, error: error.localizedDescription)
                break
            }
        })
    }*/
    
    
    /*func requestUploadJPGImage(connectionUrl: String, imageName: String, params: Parameters, files: Parameters) {
        
        Utils.CheckLog(tag: self.TAG, value: "URL: " + connectionUrl)
        Utils.CheckLog(tag: self.TAG, value: "Parameters: \(params)")
        
        print("From Url : ",self.baseUrl + connectionUrl)
        
        self.loading(status: true)
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            for (paramKey, paramValue) in params {
                multipartFormData.append((paramValue as! String).data(using: .utf8, allowLossyConversion: false)!, withName: paramKey)
            }
            for (imageKey, imageValue) in files {
                
                if let image = imageValue as? String, let imageUrl = URL.init(string: image) {
                    Utils.CheckLog(tag: "upload", value: "string, \(imageKey)")
                    multipartFormData.append(imageUrl, withName: imageKey)
                    //multipartFormData.append(imageUrl, withName: imageKey, mimeType: "image/jpg")
                } else if let imageUrl = imageValue as? URL {
                    Utils.CheckLog(tag: "upload", value: "url, \(imageKey)")
                    multipartFormData.append(imageUrl, withName: imageKey)
                } else if let imageData = imageValue as? Data {
                    print("From Connection : ", imageKey)
                    Utils.CheckLog(tag: "upload", value: "data, \(imageKey)")
                    let fileName = imageKey + ".jpg"
                    multipartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/jpg")
                    continue
                }
            }
            
        },to: self.baseUrl + connectionUrl , encodingCompletion: {
            encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                self.uploadRequest = upload
                upload.uploadProgress {
                    progress in
                    
                    let total = Float(progress.totalUnitCount)
                    Utils.CheckLog(tag: self.TAG, value: "Total: \(total)")
                    
                    let progress = Float(progress.completedUnitCount)
                    Utils.CheckLog(tag: self.TAG, value: "Progress: \(progress)")
                    
                    let percent = progress / total
                    print("From requestUpload")
                    Utils.CheckLog(tag: self.TAG, value: "Percent: \(percent)")
                    print("From requestUpload 1")
                    self.progressProtocol?.Progress(TAG: self.TAG, percent: percent)
                    print("From requestUpload 2")
                }
                upload.responseString(completionHandler: {
                    response in
                    
                    self.loading(status: false)
                    
                    if let json = response.result.value {
                        Utils.CheckLog(tag: self.TAG, value: "Json: " + json)
                        self.myProtocol.Success(TAG: self.TAG, json: json, data: nil)
                    }
                })
                
                break
            case .failure(let error):
                self.loading(status: false)
                
                Utils.CheckLog(tag: self.TAG, value: "Error: " + error.localizedDescription)
                self.myProtocol.Failure(TAG: self.TAG, error: error.localizedDescription)
                break
            }
        })
    }*/
    
    
    func requestDownload(connectionUrl : String){
        
        Utils.CheckLog(tag: self.TAG, value: "URL: " + connectionUrl)
        self.loading(status: true)
        
        let downloadUrl = URL.init(string: connectionUrl)!
        self.dataRequest = AF.request(downloadUrl).responseData { response in
            self.loading(status: false)
            
            switch response.result {
            case let .success(value):
                let downloadName = "download_\(Utils.getCurrentTime()).\(downloadUrl.pathExtension)"
                let path = Utils.getDirectoryPath().appendingPathComponent(downloadName)
                if Utils.createFile(dataPath: path, data: value) {
                    self.myProtocol.Success(TAG: self.TAG, json: path, data: value)
                } else {
                    self.myProtocol.Failure(TAG: self.TAG, error: "Failed to download file.")
                }
                break
            case let .failure(error):
                print(error)
                Utils.CheckLog(tag: self.TAG, value: "Error: " + error.localizedDescription)
                self.myProtocol.Failure(TAG: self.TAG, error: error.localizedDescription)
                break
            }
        }
    }
    
    private func loading(status: Bool, message: String = ""){
        if status {
            if self.isLoading {
                return
            }
            
            if !isInternetAvailable() {
                self.myProtocol.NoConnection(TAG: self.TAG)
                return
            }
            
            if !self.hideLoader {
                CustomActivityIndicator.show(message, userInteractionStatus: false)
            }
            
            if let control = self.refreshControl, !control.isRefreshing {
                control.beginRefreshing()
            }
            
            self.isLoading = true
            
        } else {
            CustomActivityIndicator.dismiss()
            
            if let control = self.refreshControl, control.isRefreshing {
                control.endRefreshing()
            }
            self.isLoading = false
        }
    }
    
    func isInternetAvailable() -> Bool{
        if let internet = Alamofire.NetworkReachabilityManager.init() {
            return internet.isReachable
        }
        return false
    }
    
    func cancelDataRequest(){
        if self.dataRequest != nil {
            self.dataRequest.cancel()
        }
        
        if self.uploadRequest != nil {
            self.uploadRequest.cancel()
        }
    }
    
}
