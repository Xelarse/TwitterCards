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
        let rightNow = Date()
        
        
        return ""
    }
    
}
