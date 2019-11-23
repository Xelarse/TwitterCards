//
//  FeedDataBank.swift
//  TwitterCards
//
//  Created by Alex Allman on 19/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


protocol FeedDataBankDelegate {
    func dataReady()
}

class FeedDataBank {
    enum InitType {
        case Real
        case Dummy
    }
    
    var delegate : FeedDataBankDelegate!
    
    var usersTweets = [FeedData]()
    var userHandles = [String]()
    
    var pendingFetches : Int = 0
    
    private init() {}
    
    init(initType:InitType, handles:[String]){
        userHandles = handles
        switch initType {
        case .Real:
            initRealData()
        default:
            initDummyData()
        }
    }
    
    func initDummyData(){
        let bodyText : String = "Lorem ipsum dolor sit amet consectetur adipiscing elit viverra egestas fermentum nascetur maecenas duis condimentum volutpat nulla metus augue, ad fusce feugiat non placerat consequat lectus ligula nullam cras scelerisque eget sollicitudin id risus class. Imperdiet quis nascetur."
        let profilePics : [UIImage] = [UIImage(named: "bus")!, UIImage(named: "Game Dev")!, UIImage(named: "Smash Bros")!]
        
        for x in 0...99 {
            var tweetImg : UIImage?
            if x % 2 == 0 {
                tweetImg = profilePics[x % profilePics.count]
            }
            let tweet = FeedData(handle: userHandles[Int.random(in: 0...userHandles.count - 1)], icon: profilePics[Int.random(in: 0...profilePics.count - 1)], body: bodyText, image: tweetImg, time: x, likes: 0, retweets: 0)
            usersTweets.append(tweet)
        }
        
    }
    
    
    func initRealData(){
        
        var fixedHandles = [String]()
        
        for handle in userHandles {
            var newHandle = handle
            if let index = newHandle.firstIndex(of: "@"){
                newHandle.remove(at: index)
                fixedHandles.append(newHandle)
            }
            else {
                fixedHandles.append(newHandle)
            }
        }
        
        pendingFetches = fixedHandles.count
        
        for handle in fixedHandles {
            TwitterApi.shared.getUserTweets(callback: { (tweetArray) in
                for tweet in tweetArray{
                    self.usersTweets.append(self.createFeedDataFromTweet(tweet: tweet))
                    self.pendingFetches -= 1
                    if self.pendingFetches == 0{
                        self.delegate.dataReady()
                    }
                }
            }, screenName: handle, tweetCount: 30, includeRts: true)
        }
        
    }
    
    func createFeedDataFromTweet(tweet : Tweet) -> FeedData {
        let newFeedData = FeedData()
        newFeedData.userHandle = tweet.userHandle
        newFeedData.tweetBody = tweet.tweetText
        newFeedData.tweetLikes = tweet.likeCount
        newFeedData.tweetRetweets = tweet.retweetCount
        newFeedData.tweetTime = 0
        
        if let url = URL(string: tweet.userIcon) {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url)
                {
                    DispatchQueue.main.async {
                        newFeedData.userIcon = UIImage( data:data)!
                    }
                }
                else {
                    DispatchQueue.main.async {
                        newFeedData.userIcon = UIImage(named: "blank")!
                    }
                }
            }
        }
        
        if tweet.thumbnailUrl != ""{
            if let url = URL(string: tweet.thumbnailUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data( contentsOf:url)
                    {
                        DispatchQueue.main.async {
                            newFeedData.userIcon = UIImage( data:data)!
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            newFeedData.userIcon = UIImage(named: "blank")!
                        }
                    }
                }
            }
        }
        
        return newFeedData
    }
}
