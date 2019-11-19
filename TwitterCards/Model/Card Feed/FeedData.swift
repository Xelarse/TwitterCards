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
    var userIcon : UIImage
    var tweetBody : String
    var tweetImage : UIImage?
    var tweetTime : String
    var tweetLikes : Int
    var tweetRetweets : Int
    
    init(handle:String, icon:UIImage, body:String, image:UIImage?, time:String, likes:Int, retweets:Int) {
        userHandle = handle
        userIcon = icon
        tweetBody = body
        tweetImage = image
        tweetTime = time
        tweetLikes = likes
        tweetRetweets = retweets
    }
    
    init(){
        userHandle = ""
        userIcon = UIImage(named: "blank")!
        tweetBody = ""
        tweetImage = nil
        tweetTime = ""
        tweetLikes = 0
        tweetRetweets = 0
    }
}
