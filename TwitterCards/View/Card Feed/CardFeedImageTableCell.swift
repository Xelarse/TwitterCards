//
//  CardFeedImageTableCell.swift
//  TwitterCards
//
//  Created by Alex Allman on 20/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class CardFeedImageTableCell : UITableViewCell {
    
    @IBOutlet weak var userHandle : UILabel!
    @IBOutlet weak var userIcon : UIImageView!
    @IBOutlet weak var tweetBody : UILabel!
    @IBOutlet weak var tweetImage : UIImageView!
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
        if cellData.tweetImage != nil{
            let oldFrame = tweetImage.frame
            let newFrame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: oldFrame.width)
            tweetImage.frame = newFrame
            tweetImage.image = cellData.tweetImage
        }
        tweetTime.text = String(cellData.tweetTime)
        tweetLikes.text = String(cellData.tweetLikes)
        tweetRetweets.text = String(cellData.tweetRetweets)
    }
    
}
