//
//  SelectionCarousel.swift
//  TwitterCards
//
//  Created by Alex Allman on 12/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class SelectionCarousel{
    var title : String
    var backgroundColour : UIColor   //Colour in hash
    var backgroundImage : UIImage  //File name of image
    var handleArray : [String]
    
    init(cellTitle:String, cellBgColour:UIColor, cellBgImage:UIImage, handles:[String]) {
        title = cellTitle
        backgroundColour = cellBgColour
        backgroundImage = cellBgImage
        handleArray = handles
    }
    
    init(){
        title = ""
        backgroundColour = UIColor.white
        backgroundImage = UIImage.init(named: "blank")!
        handleArray = [""]
    }
}
