//
//  CardFeedViewController.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class CardFeedViewController: UIViewController {

    @IBOutlet weak var testText : UILabel!
    
    var handles : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testText.text = handles.description
    }
    
    func initHandles(handleArray : [String]){
        handles = handleArray
        print("Handles init!")
        print(handles)
    }
    
}
