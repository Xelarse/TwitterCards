//
//  ReplyFeedViewController.swift
//  TwitterCards
//
//  Created by Alex Allman on 11/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import UIKit

class ReplyFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var feedBank : FeedDataBank!
    var rootTweetId : String = ""
    var userHandle : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        feedBank = FeedDataBank(userHandle: userHandle, tweetId: rootTweetId)
        feedBank.delegate = self
        
        //Set up right swipe gesture
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGesture(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableView.automaticDimension;
    }

    func initialiseRootId(id : String, handle : String){
        rootTweetId = id
        userHandle = handle
    }
    
    @objc func swipeRightGesture(_ sender:UISwipeGestureRecognizer){
        if sender.state == .ended{
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - TableView Extensions
extension ReplyFeedViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedBank.usersTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsData = feedBank.usersTweets[indexPath.row]
        
        if cellsData.tweetImage != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardFeedImageTableCell") as! CardFeedImageTableCell
            cell.cellData = cellsData
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardFeedTableCell") as! CardFeedTableCell
            cell.cellData = cellsData
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//Mark: - Feed bank delegate extensions
extension ReplyFeedViewController : FeedDataBankDelegate {
    func dataReady() {
        //TODO Stop loading symbol if it gets added
        self.tableView.reloadData()
    }
    
    func updateCellAtIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
