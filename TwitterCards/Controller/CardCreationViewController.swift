//
//  CardCreationViewController.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

protocol NewCardDelegate {
    func passNewCardDetails(title : String, handles : [String])
}

class CardCreationViewController: UIViewController {
    
    var newCardDelegate : NewCardDelegate!
    
    var handles : [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Title", message: "Give a name to the new card", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            field.placeholder = "Enter title here"
            field.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: { (UIAlertAction) in
            if let inputField = alert.textFields?[0] {
                if let inputText = inputField.text {
                    self.newCardDelegate.passNewCardDetails(title: inputText, handles: self.handles)
                    let _ =  self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.invalidTitleEntry()
                }
            }
            else{
                self.invalidTitleEntry()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //Go back to the previous scene with no changes, this can most likely stay as is
        let _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presentAddWindow()
    }
    
    func presentAddWindow(){
        let alert = UIAlertController(title: "Add New Handle or Hashtag", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (field) in
            field.placeholder = "Enter the '@' or '#' here!"
            field.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            if let input = alert.textFields?[0]{
                if let inputText = input.text {
                    if inputText.first == "@" || inputText.first == "#"{
                        self.handles.append(inputText)
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self.invalidTwitterEntryAlert()
                    }
                }
                else {
                    self.invalidTwitterEntryAlert()
                }
            }
            else {
                self.invalidTwitterEntryAlert()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    func invalidTwitterEntryAlert(){
        let alert = UIAlertController(title: "Error", message: "Must enter a valid Twitter handle or Hashtag", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    func invalidTitleEntry(){
        let alert = UIAlertController(title: "Error", message: "Invalid title entry", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
    }
}
