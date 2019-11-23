//
//  TwitterApi.swift
//  TwitterCards
//
//  Created by Alex Allman on 19/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TwitterApi {
    
    let consumerKey = "miGXqUEm22akKCLygliLqnuh3"
    let consumerSecret = "ybSYyNFGCmbH9FMHZm6xF8fhbnt7eMZd9sQ3SqmYJNIdOhYA7D"
    var apiAccessToken : String = ""
    
    static let shared = TwitterApi()
    
    private init(){
    }
    
    func retreiveAccessToken(){
        let encodeMe = consumerKey + ":" + consumerSecret
        let utf8Encoded = encodeMe.data(using: .utf8)
        let base64 = utf8Encoded?.base64EncodedString()
        
        let requestUrl = "https://api.twitter.com/oauth2/token";
        let header = ["Authorization" : "Basic " + base64!, "Content-Type" : "application/x-www-form-urlencoded;charset=UTF-8."]
        let body = "grant_type=client_credentials"
        
        AF.request(requestUrl, method: .post, parameters: [:], encoding: body, headers: HTTPHeaders(header)).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let token = json["access_token"].string {
                    print("Twitter Api Token Successfully received")
                    self.apiAccessToken = token
                }
                else {
                    print("Token received but error unwrapping optional")
                }
            case .failure(let error):
                print(error)
            }
        }

    }
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
