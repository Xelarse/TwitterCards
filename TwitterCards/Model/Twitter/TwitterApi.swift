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
                    print("Twitter Api Token Successfully Received")
                    self.apiAccessToken = token
                }
                else {
                    print("Token received but error unwrapping optional")
                }
            case .failure(let error):
                print("Twitter Api Token Error: ")
                print(error)
            }
        }
    }
    
    func getUserTweets(callback: @escaping ([Tweet]) -> Void, screenName : String, tweetCount : Int, includeRts : Bool = false, excludeReplies : Bool = true){
        
        if apiAccessToken == ""{
            print("Api token is not initialised, Cannot complete request, attempting to initialise")
            retreiveAccessToken()
            callback([Tweet]())
            return
        }
        
        let requestUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let requestHeader = [
            "Authorization" : "Bearer " + self.apiAccessToken
        ]
        let requestParameters = [
            "screen_name" : screenName,
            "count" : String(tweetCount > 200 ? 200 : tweetCount),
            "include_rts" : includeRts ? "true" : "false",
            "exclude_replies" : excludeReplies ? "true" : "false"
        ]
        
        AF.request(requestUrl, method: .get, parameters: requestParameters, encoder: URLEncodedFormParameterEncoder.default, headers: HTTPHeaders(requestHeader)).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print("User tweets successfully received")
                let tweetJson = JSON(value)
                let tweets = self.jsonResponseToTweetArray(tweetJson: tweetJson)
                callback(tweets)
            case .failure(let error):
                print("User tweets unsuccessfully received")
                print(error)
                callback([Tweet]())
            }
        }
    }
    
    func jsonResponseToTweetArray(tweetJson : JSON) -> [Tweet] {
        var tweets = [Tweet]()
        
        for (index,subJson):(String, JSON) in tweetJson {
            let tweet = Tweet()
            tweet.createdAt = subJson["created_at"].string ?? tweet.createdAt
            tweet.tweetId = subJson["id"].int ?? tweet.tweetId
            tweet.tweetText = subJson["text"].string ?? tweet.tweetText
            tweet.thumbnailUrl = subJson["entities"]["media"][0]["media_url_https"].string ?? tweet.thumbnailUrl
            tweet.likeCount = subJson["favorite_count"].int ?? tweet.likeCount
            tweet.retweetCount = subJson["retweet_count"].int ?? tweet.retweetCount
            tweet.userIcon = subJson["user"]["profile_image_url_https"].string ?? tweet.userIcon
            tweet.userHandle = subJson["user"]["screen_name"].string ?? tweet.userHandle
            
            tweets.append(tweet)
        }
        
        
        return tweets
    }
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
