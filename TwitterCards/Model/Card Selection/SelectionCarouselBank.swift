//
//  SelectionCarouselBank.swift
//  TwitterCards
//
//  Created by Alex Allman on 12/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit
import CoreData
import Foundation

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
        carouselCells.append(SelectionCarousel(cellTitle: "Game Dev", cellBgColour: UIColor(red: 114.0/255.0, green: 234.0/255.0, blue: 136.0/255.0, alpha: 0.6), cellBgImage: UIImage(named: "Game Dev")! , handles: ["@tha_rami", "@JagexAsh", "@JagexKieren"]))

        carouselCells.append(SelectionCarousel(cellTitle: "Smash", cellBgColour: UIColor(red: 234.0/255.0, green: 110.0/255.0, blue: 110.0/255.0, alpha: 0.6), cellBgImage: UIImage(named: "Smash Bros")!, handles: ["@NairoMK", "@theSirToasty", "@Samsora_"]))
        
        carouselCells.append(SelectionCarousel(cellTitle: "Bristol Bus", cellBgColour: UIColor(red: 195.0/255.0, green: 117.0/255.0, blue: 229.0/255.0, alpha: 0.6), cellBgImage: UIImage(named: "bus")!, handles: ["@FirstBSA"]))
    }
    
    func initWithRealData(){
        let storedSelectionCards = PersistanceService.fetch(_objectType: SelectionCard.self)
        
        storedSelectionCards.forEach { (card) in
            let selectionCarouselItem = SelectionCarousel()
            selectionCarouselItem.title = card.cardTitle
            selectionCarouselItem.backgroundImage = UIImage(named: card.backgroundImg)!
            selectionCarouselItem.backgroundColour = UIColor(red: CGFloat(card.backgroundColorR), green: CGFloat(card.backgroundColorG), blue: CGFloat(card.backgroundColorB), alpha: 0.65)
            selectionCarouselItem.handleArray = stringToStringArray(string: card.handlesArray)
            carouselCells.append(selectionCarouselItem)
        }
        
    }
    
    func saveUpdatedBank(){
        //First delete whats currently stored in the bank then save the new stuff not the most effecient but quick and dirty
        let existingCards = PersistanceService.fetch(_objectType: SelectionCard.self)
        existingCards.forEach { (card) in
            PersistanceService.context.delete(card)
        }
        
        //TODO find a replacement to save out custom images for custom backgrounds
        carouselCells.forEach { (cell) in
            let selectCard = SelectionCard(context: PersistanceService.context)
            selectCard.cardTitle = cell.title
            selectCard.backgroundImg = "blank"
            selectCard.handlesArray = stringArrayToString(array: cell.handleArray)
            
            if let colorComponents = cell.backgroundColour.cgColor.components {
                selectCard.backgroundColorR = Float(colorComponents[0])
                selectCard.backgroundColorG = Float(colorComponents[1])
                selectCard.backgroundColorB = Float(colorComponents[2])
            }
            else {
                selectCard.backgroundColorR = 0.0
                selectCard.backgroundColorG = 0.0
                selectCard.backgroundColorB = 0.0
            }
        }
        PersistanceService.saveContext()
    }
    
    func addNewCardToBank(title : String, handles : [String], color : UIColor, backgroundImgName : String){
        let newCell = SelectionCarousel(cellTitle: title, cellBgColour: color, cellBgImage: UIImage(named: backgroundImgName)!, handles: handles)
        carouselCells.append(newCell)
    }
    
    func removeCardFromBank(index: Int){
        carouselCells.remove(at: index)
    }
    
    func stringArrayToString(array: [String]) -> String {
        let arrayString = array.joined(separator: "-")
        return arrayString
    }
    
    func stringToStringArray(string : String) -> [String] {
        let array = string.components(separatedBy: "-")
        return array
    }
}
