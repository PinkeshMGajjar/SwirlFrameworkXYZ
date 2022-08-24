//
//  SwirlsAPIService.swift
//  GetNatty
//
//  Created by pinkesh gajjar on 30/11/20.
//

import UIKit
import Alamofire

class SwirlsAPIService: NSObject {

    static let sharedInstance = SwirlsAPIService()
    var swirlDataObject : SwirlsData? = nil
    
    func getSwrilData(completion: @escaping (SwirlsData) -> Void) {
        
        let parameters: [String: Any] = [
            "designer_id": "19791"
        ]
        
        if Connectivity.isConnectedToInternet {
              
            AF.request("https://store.goswirl.live/index.php/api/Designer/newdashboard", method: .post, parameters: parameters).responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    if let json = response.value {
                        let jsonDict = json as! NSDictionary
                        print("From JsonDict :: ", jsonDict)
                        self.swirlDataObject = SwirlsData(jsonData: jsonDict)
                        completion(self.swirlDataObject!)
                    }
                    break
                case .failure(let error):
                    print("From Response: ", error)
                    break
                }

//                if let status = response.response?.statusCode {
//                    switch(status){
//                    case 200:
//                        print("Response Received ...!!")
//                    default:
//                        print("error with response status: \(status)")
//                    }
//                }
//                
//                print("From Response: ", response.result)
//                
//                if let result = response.value {
//                    let JSON = result as! NSDictionary
//                    self.swirlDataObject = SwirlsData(jsonData: JSON)
//                    completion(self.swirlDataObject!)
//                }
            }
        }
    }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
