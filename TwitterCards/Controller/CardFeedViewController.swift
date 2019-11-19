//
//  CardFeedViewController.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit
import Transition

class CardFeedViewController: UIViewController {

    @IBOutlet weak var testText : UILabel!
    
    var feedBank : FeedDataBank!
    var handles : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up right swipe gesture
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGesture(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        testText.text = handles.description
        feedBank = FeedDataBank(initType: .Dummy, handles: handles)
    }
    
    func initHandles(handleArray : [String]){
        handles = handleArray
        print("Handles init!")
        print(handles)
    }
    
    @objc func swipeRightGesture(_ sender:UISwipeGestureRecognizer){
        if sender.state == .ended{
            let _ = navigationController?.popViewController(animated: true)
        }
    }
}
