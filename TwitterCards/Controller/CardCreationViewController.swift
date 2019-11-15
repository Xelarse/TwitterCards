//
//  CardCreationViewController.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class CardCreationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        //Create a new card and tell the previous scene to refresh its cards then pop back to it
        let _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //Go back to the previous scene with no changes, this can most likely stay as is
        let _ = navigationController?.popViewController(animated: true)

    }
    
    
}
