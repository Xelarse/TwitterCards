//
//  CardFeedTableCell.swift
//  TwitterCards
//
//  Created by Alex Allman on 19/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class CardFeedTableCell : UITableViewCell {
    
    @IBOutlet weak var userHandle : UILabel!
    @IBOutlet weak var userIcon : UIImageView!
    @IBOutlet weak var tweetBody : UILabel!
    @IBOutlet weak var tweetTime : UILabel!
    @IBOutlet weak var tweetLikes : UILabel!
    @IBOutlet weak var tweetRetweets : UILabel!
    
    
    var cellData : FeedData!{
        didSet{
            self.updateCell()
        }
    }
    
    func updateCell() {
        userHandle.text = cellData.userHandle
        userIcon.image = cellData.userIcon
        userIcon.contentMode = .scaleAspectFill
        userIcon.layer.cornerRadius = 10.0
        tweetBody.text = cellData.tweetBody
        tweetTime.text = calculateTimeFromDate(date: cellData.tweetDate)
        tweetLikes.text = String(cellData.tweetLikes)
        tweetRetweets.text = String(cellData.tweetRetweets)
    }
    
    func calculateTimeFromDate(date : Date) -> String {
        //Take the date object, compare it to the current time and get a diff to display
        let calendar = Calendar.current
        let rightNow = Date()
        
        let timePeriod = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: cellData.tweetDate, to: rightNow)
        
        if let month = timePeriod.month {
            if month > 0 {
                return String(month) + "mn"
            }
        }
        
        if let day = timePeriod.day {
            if day > 0 {
                return String(day) + "d"
            }
        }
        
        if let hour = timePeriod.hour {
            if hour > 0 {
                return String(hour) + "h"
            }
        }
        
        if let min = timePeriod.minute {
            if min > 0 {
                return String(min) + "m"
            }
        }
        
        if let sec = timePeriod.second {
            if sec > 0 {
                return String(sec) + "s"
            }
        }
        
        return "Date Error"
    }
    
}
