//
//  CardSelectionViewController.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit
import Transition

class CardSelectionViewController: UIViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var noCardsLabel: UILabel!
    
    let colCelScaleX : CGFloat = 0.8
    let colCelScaleY : CGFloat = 0.8
    
    var selectionBank = SelectionCarouselBank(initType: SelectionCarouselBank.InitialisationType.Real)
    
    var editingMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionViewSetup
        let colViewSize = view.bounds.size
        let colCelWidth = floor(colViewSize.width * colCelScaleX)
        let colCelHeight = floor(colViewSize.height * colCelScaleY)
        let colCelInsetX = (colViewSize.width - colCelWidth) / 2.0
        let colCelInsetY = (colViewSize.height - colCelHeight) / 2.0
        
        let colViewLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        
        colViewLayout.itemSize = CGSize(width: colCelWidth, height: colCelHeight)
        collectionView.contentInset = UIEdgeInsets(top: colCelInsetY, left: colCelInsetX, bottom: colCelInsetY, right: colCelInsetX)
        

        //Delegate this view controler to the collection views datasource AKA this controls it
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if selectionBank.carouselCells.count == 0{
            noCardsLabel.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectionBank.saveUpdatedBank()
        super.viewDidDisappear(animated)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let cardAddVC = storyboard?.instantiateViewController(withIdentifier: "CardCreationViewController") as! CardCreationViewController
        cardAddVC.newCardDelegate = self
        navigationController?.pushViewController(cardAddVC, animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        toggleEditing()
    }
    
    func toggleEditing(){
        editingMode = !editingMode
        editButton.title = editingMode ? "Done" : "Edit"
        addButton.isEnabled = editingMode ? false : true
        collectionView.reloadData()
    }
}

//MARK: - Extension logic for the CollectionViewDataSource

extension CardSelectionViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionBank.carouselCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create a new cell using our identifier set in editor and cast it to our custom class that inherited from the base collectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardSelectCollectionCell", for: indexPath) as! CardSelectCollectionCell
        
        let thisCellInfo = selectionBank.carouselCells[indexPath.item]
        
        cell.cellInfo = thisCellInfo
        cell.cellDelegate = self
        cell.setEditingLayout(isEnabled: editingMode)
        
        return cell
    }
}

extension CardSelectionViewController : UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //Logic for snapping the carousel to the center of the screen
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingCellPadding = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingCellPadding
        
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingCellPadding - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //After selecting a collection cell get the handles from that cell, instantiate a new cardfeedview and set it as the delegate and send it the handles
        
        if !editingMode{
            let handlesToSend = selectionBank.carouselCells[indexPath.item].handleArray
            
            let cardFeedVC = storyboard?.instantiateViewController(withIdentifier: "CardFeedViewController") as! CardFeedViewController
            cardFeedVC.initHandles(handleArray: handlesToSend)
            navigationController?.pushViewController(cardFeedVC, animated: true)
        }
    }
}

//MARK: - Extension logic for the CardCreationViewController

extension CardSelectionViewController : NewCardDelegate {
    func passNewCardDetails(title : String, handles : [String]){
        //Generates the properties to add to the array of SelectionCarouselBank
        
        let cardColor = UIColor(red: CGFloat.random(in: 0..<1), green: CGFloat.random(in: 0..<1), blue: CGFloat.random(in: 0..<1), alpha: 0.6)
        
        selectionBank.addNewCardToBank(title: title, handles: handles, color: cardColor, backgroundImgName: "blank")
        
        noCardsLabel.isHidden = true
        
        selectionBank.saveUpdatedBank()
        selectionBank.sortArrayByTitle()
        self.collectionView.reloadData()
    }
}

//MARK: - Extension logic for CardSelectCollectionCellDeletgate
extension CardSelectionViewController : CardSelectCollectionCellDelegate {
    func removeCell(cellInfo: SelectionCarousel) {
        if let index = selectionBank.carouselCells.firstIndex(where: {$0.title == cellInfo.title}){
            let indexPath = IndexPath(row: index, section: 0)
            selectionBank.carouselCells.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            
            if selectionBank.carouselCells.count == 0 {
                noCardsLabel.isHidden = false
                toggleEditing()
            }
        }
    }
    
    func editCellData(cellInfo: SelectionCarousel) {
        if let index = selectionBank.carouselCells.firstIndex(where: {$0.title == cellInfo.title}){
            let existingHandles = selectionBank.carouselCells[index].handleArray
            toggleEditing()
            selectionBank.carouselCells.remove(at: index)
            
            let cardAddVC = storyboard?.instantiateViewController(withIdentifier: "CardCreationViewController") as! CardCreationViewController
            cardAddVC.newCardDelegate = self
            cardAddVC.handles = existingHandles
            cardAddVC.setEditingExistingCard()
            navigationController?.pushViewController(cardAddVC, animated: true)
        }
    }
}
