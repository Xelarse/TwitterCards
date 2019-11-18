//
//  CardCreationTableCell.swift
//  TwitterCards
//
//  Created by Alex Allman on 16/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class CardCreationTableCell : UITableViewCell {
    @IBOutlet weak var cellText : UILabel!
    
    var handleString : String = "" {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        cellText.text = handleString
    }
}
