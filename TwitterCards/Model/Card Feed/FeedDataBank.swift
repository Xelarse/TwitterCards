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
    func updateCellAtIndex(index : Int)
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
            let tweet = FeedData(handle: userHandles[Int.random(in: 0...userHandles.count - 1)], icon: profilePics[Int.random(in: 0...profilePics.count - 1)], body: bodyText, image: tweetImg, likes: 0, retweets: 0, id: 0, date: Date())
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
                }
                self.pendingFetches -= 1
                if self.pendingFetches == 0{
                    self.sortFeedByDateDecending()
                    self.delegate.dataReady()
                }
                
            }, screenName: handle, tweetCount: 50, includeRts: true)
        }
        
    }
    
    func createFeedDataFromTweet(tweet : Tweet) -> FeedData {
        let newFeedData = FeedData()
        newFeedData.userHandle = tweet.userHandle
        newFeedData.tweetBody = tweet.tweetText
        newFeedData.tweetLikes = tweet.likeCount
        newFeedData.tweetRetweets = tweet.retweetCount
        newFeedData.tweetId = tweet.tweetId
        newFeedData.tweetDate = dateFromCreatedString(dateString: tweet.createdAt)
        
        if let url = URL(string: tweet.userIcon) {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url)
                {
                    DispatchQueue.main.async {
                        newFeedData.userIcon = UIImage( data:data)!
                        self.pushRequestToUpdateItem(data: newFeedData)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        newFeedData.userIcon = UIImage(named: "blank")!
                        self.pushRequestToUpdateItem(data: newFeedData)
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
                            newFeedData.tweetImage = UIImage( data:data)!
                            self.pushRequestToUpdateItem(data: newFeedData)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            newFeedData.tweetImage = UIImage(named: "blank")!
                            self.pushRequestToUpdateItem(data: newFeedData)
                        }
                    }
                }
            }
        }
        
        return newFeedData
    }
    
    func pushRequestToUpdateItem(data : FeedData){
        var cellIndex = 0
        
        for ind in 0...usersTweets.count - 1{
            if usersTweets[ind].tweetId == data.tweetId{
                cellIndex = ind
                break
            }
        }
        delegate.updateCellAtIndex(index: cellIndex)
    }
    
    func dateFromCreatedString(dateString : String) -> Date {
        let calendar = Calendar.current
        let elements = dateString.components(separatedBy: " ")
        let hourMinSec = elements[3].components(separatedBy: ":")
        
        let day = Int(elements[2])
        let month = changeMonthStringToInt(str: elements[1])
        let year = Int(elements[5])
        let hour = Int(hourMinSec[0])
        let min = Int(hourMinSec[1])
        let sec = Int(hourMinSec[2])
        let timezone = changeSecondsFromGmtToTimeZone(str: elements[4])
        
        let dateComponents = DateComponents(calendar: calendar, timeZone: timezone, year: year, month: month, day: day, hour: hour, minute: min, second: sec)
        
        let tweetDate = calendar.date(from: dateComponents)
        
        return tweetDate ?? Date()
    }
    
    func changeMonthStringToInt(str : String) -> Int{
        switch str {
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        case "Dec":
            return 12
        default:
            return 1
        }
    }
    
    func changeSecondsFromGmtToTimeZone(str : String) -> TimeZone{
        let stringStart = str.first!
        let fallbackTimezone = TimeZone(secondsFromGMT: 0)!
        
        if stringStart == "+"{
            var value = str
            value.remove(at: value.firstIndex(of: "+")!)
            let valueInt = Int(value) ?? 0
            return TimeZone(secondsFromGMT: valueInt) ?? fallbackTimezone
        }
        else if stringStart == "-"{
            var value = str
            value.remove(at: value.firstIndex(of: "-")!)
            let valueInt = Int(value) ?? 0
            return TimeZone(secondsFromGMT: valueInt) ?? fallbackTimezone
        }
        return fallbackTimezone
    }
    
    func sortFeedByDateDecending() {
        usersTweets = usersTweets.sorted(by: {$0.tweetDate.compare($1.tweetDate) == .orderedDescending})
    }
}
