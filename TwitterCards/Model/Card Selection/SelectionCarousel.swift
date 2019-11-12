//
//  SelectionCarousel.swift
//  TwitterCards
//
//  Created by Alex Allman on 12/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit


class SelectionCarousel{
    let title : String
    let backgroundColour : UIColor   //Colour in hash
    let backgroundImage : UIImage    //File name of image
    let handleArray : [String]
    
    init(cellTitle:String, cellBgColour:UIColor, cellBgImage:UIImage, handles:[String]) {
        title = cellTitle
        backgroundColour = cellBgColour
        backgroundImage = cellBgImage
        handleArray = handles
    }
}
