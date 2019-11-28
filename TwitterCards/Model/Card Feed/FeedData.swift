//
//  FeedData.swift
//  TwitterCards
//
//  Created by Alex Allman on 19/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit
import Foundation


class FeedData {
    var userHandle : String
    var userName : String
    var userIcon : UIImage
    var tweetBody : String
    var tweetImage : UIImage?
    var tweetDate : Date
    var tweetLikes : Int
    var tweetRetweets : Int
    var tweetId : String
    
    init(handle:String, icon:UIImage, body:String, image:UIImage?, likes:Int, retweets:Int, id:String, date: Date, name:String) {
        userHandle = handle
        userIcon = icon
        tweetBody = body
        tweetImage = image
        tweetLikes = likes
        tweetRetweets = retweets
        tweetId = id
        tweetDate = date
        userName = name
    }
    
    init(){
        userHandle = ""
        userIcon = UIImage(named: "blank")!
        tweetBody = ""
        tweetImage = nil
        tweetLikes = 0
        tweetRetweets = 0
        tweetId = ""
        tweetDate = Date()
        userName = ""
    }
}
