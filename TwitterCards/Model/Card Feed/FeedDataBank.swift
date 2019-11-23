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

class FeedDataBank {
    enum InitType {
        case Real
        case Dummy
    }
    
    var tweets = [FeedData]()
    var userHandles = [String]()
    
    
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
            tweets.append(tweet)
        }
        
    }
    
    
    func initRealData(){
    
    }
}
