//
//  NetworkManager.swift
//  TruckMap
//
//  Created by Mac on 07/04/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() { }
    
    func callingHTTPAPI(urlString: String, completion: @escaping (_ responsedata: JSON?, _ error: Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        AF.request(url, method: .get, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let json):
                let obj = JSON(json)
                print("Sucess with JSON: -> \(obj)")
                completion(obj, nil)
            case .failure(let error):
                print("Error -> \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
}
