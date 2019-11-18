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
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var handles : [String] = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        enterCardTitleAlert()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //Go back to the previous scene with no changes, this can most likely stay as is
        let _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        checkAndAddHandleToArray()
    }
    
    func checkAndAddHandleToArray(){
        if let fieldText : String = textField.text{
            if fieldText.first == "@" || fieldText.first == "#" {
                handles.append(fieldText)
                
                let indexPath = IndexPath(row: handles.count - 1, section: 0)
                
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
                textField.text = ""
                view.endEditing(true)
            }
            else{
                invalidTwitterEntryAlert()
            }
        }
        else{
            invalidTwitterEntryAlert()
        }
    }
    
    func invalidTwitterEntryAlert(){
        let alert = UIAlertController(title: "Error", message: "Must enter a valid Twitter handle or Hashtag", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    func invalidTitleEntryAlert(){
        let alert = UIAlertController(title: "Error", message: "Invalid title entry", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    func enterCardTitleAlert(){
        let alert = UIAlertController(title: "Enter Title", message: "Give a name to the new card", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            field.placeholder = "Enter title here"
            field.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: { (UIAlertAction) in
            if let inputField = alert.textFields?[0] {
                if let inputText = inputField.text {
                    self.newCardDelegate.passNewCardDetails(title: inputText, handles: self.handles)
                    let _ =  self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.invalidTitleEntryAlert()
                }
            }
            else{
                self.invalidTitleEntryAlert()
            }
        }))
        
        self.present(alert, animated: true)
    }
}

//MARK: - TableView Extensions
extension CardCreationViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCreationTableCell") as! CardCreationTableCell
        cell.handleString = handles[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            handles.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
}
