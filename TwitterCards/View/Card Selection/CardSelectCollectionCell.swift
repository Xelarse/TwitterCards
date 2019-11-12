//
//  CardSelectCollectionCell.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class CardSelectCollectionCell : UICollectionViewCell{
    @IBOutlet weak var backgroundImageView : UIImageView!
    @IBOutlet weak var backgroundTintView : UIView!
    @IBOutlet weak var cellLabel : UILabel!
    
    var cellInfo : SelectionCarousel!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        //Once cellInfo gets set on the cell it updates the image tint and label to match the info inputted, rounds off the boxes too
        
        if cellInfo != nil {
            backgroundImageView.image = cellInfo.backgroundImage
            backgroundTintView.tintColor = cellInfo.backgroundColour
            cellLabel.text = cellInfo.title
        }
        else{
            backgroundImageView.image = nil
            backgroundTintView.tintColor = nil
            cellLabel.text = nil
        }
        
        backgroundImageView.layer.cornerRadius = 10.0
        backgroundImageView.layer.masksToBounds = true
        backgroundTintView.layer.cornerRadius = 10.0
        backgroundTintView.layer.masksToBounds = true
    }
}
