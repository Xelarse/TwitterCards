//
//  ReplyFeedImageTableCell.swift
//  TwitterCards
//
//  Created by Alex Allman on 26/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit
import Foundation

class ReplyFeedImageTableCell : TweetImageCell {
    @IBOutlet weak var topViewUpperBlueLine : UIView?
    @IBOutlet weak var topViewLowerBlueLine : UIView?
    @IBOutlet weak var centerViewBlueLine : UIView?
    @IBOutlet weak var bottomViewBlueLine : UIView?
    
    
    func setHeadBlueLineActive(isActive:Bool){
        topViewUpperBlueLine?.isHidden = !isActive
    }
    
    func setTailBlueLineActive(isActive:Bool){
        topViewLowerBlueLine?.isHidden = !isActive
        centerViewBlueLine?.isHidden = !isActive
        bottomViewBlueLine?.isHidden = !isActive
    }}
