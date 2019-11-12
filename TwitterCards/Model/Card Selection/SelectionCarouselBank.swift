//
//  SelectionCarouselBank.swift
//  TwitterCards
//
//  Created by Alex Allman on 12/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class SelectionCarouselBank{
    var carouselCells = [SelectionCarousel]()
    
    enum InitialisationType {
        case Dummy
        case Real
    }
    
    init(initType:InitialisationType) {
        switch initType {
        case InitialisationType.Dummy:
            initWithDummyData()
        case InitialisationType.Real:
            initWithRealData()
        }
    }
    
    func initWithDummyData(){
        carouselCells.append(SelectionCarousel(cellTitle: "Game Dev", cellBgColour: UIColor(red: 114.0/255.0, green: 234.0/255.0, blue: 136.0/255.0, alpha: 1.0), cellBgImage: UIImage(named: "Game Dev")! , handles: ["@tha_rami", "@JagexAsh", "@JagexKieren"]))
        
        carouselCells.append(SelectionCarousel(cellTitle: "Smash", cellBgColour: UIColor(red: 234.0/255.0, green: 110.0/255.0, blue: 110.0/255.0, alpha: 1.0), cellBgImage: UIImage(named: "Smash Bros")!, handles: ["@NairoMK", "@theSirToasty", "@Samsora_"]))
        
        carouselCells.append(SelectionCarousel(cellTitle: "Bristol Bus", cellBgColour: UIColor(red: 195.0/255.0, green: 117.0/255.0, blue: 229.0/255.0, alpha: 1.0), cellBgImage: UIImage(named: "bus")!, handles: ["@FirstBSA"]))
    }
    
    func initWithRealData(){
        //TODO read in from locally saved data what cards have been initialised and with what @s
    }
}
