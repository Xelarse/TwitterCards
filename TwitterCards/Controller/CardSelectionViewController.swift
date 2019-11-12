//
//  CardSelectionViewController.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class CardSelectionViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    var selectionBank = SelectionCarouselBank(initType: SelectionCarouselBank.InitialisationType.Dummy)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegate this view controler to the collection views datasource AKA this controls it
        collectionView.dataSource = self
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
        
        return cell
    }
}
