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

    enum NextSceneType {
        case Feed
        case Add
    }
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    let colCelScaleX : CGFloat = 0.8
    let colCelScaleY : CGFloat = 1
    
    var selectionBank = SelectionCarouselBank(initType: SelectionCarouselBank.InitialisationType.Dummy)
    
    //Transition related vars
    let panInteractionController = PanInteractionController(forNavigationTransitionsAtEdge: .right)
    var transitionController: TransitionController?
    
    let transitionDuration : Double = 0.5
    let transitionType : TransitionCatalog = .push
    var nextScene : NextSceneType = .Feed
    var handlesToSend : [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionViewSetup
        let colViewSize = collectionView.bounds.size
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
        
        //Transitions setup
        transitionController = TransitionController(forInteractiveTransitionsIn: navigationController!, transitionsSource: self, operationDelegate: self, interactionController: panInteractionController)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func SwitchScene(){
        switch nextScene{
        case .Feed:
            let cardFeedVC = storyboard?.instantiateViewController(withIdentifier: "CardFeedViewController") as! CardFeedViewController
            cardFeedVC.initHandles(handleArray: handlesToSend)
            navigationController?.pushViewController(cardFeedVC, animated: true)
            
        default: break
        }
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

extension CardSelectionViewController : UICollectionViewDelegate, UIScrollViewDelegate{
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
        handlesToSend = selectionBank.carouselCells[indexPath.item].handleArray
        nextScene = .Feed
        SwitchScene()
    }
}

//Mark: - Transition related extensions
extension CardSelectionViewController : TransitionsSource {
    
    func transitionFor(operationContext: TransitionOperationContext, interactionController: TransitionInteractionController?) -> Transition {
        return Transition(duration: transitionDuration, animation: transitionType.transitionAnimation)
    }
}

extension CardSelectionViewController : InteractiveNavigationTransitionOperationDelegate {
    
    func performOperation(operation: UINavigationController.Operation, forInteractiveTransitionIn controller: UINavigationController, gestureRecognizer: UIGestureRecognizer) {
    }
}
