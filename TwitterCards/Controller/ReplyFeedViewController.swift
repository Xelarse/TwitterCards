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
    @IBOutlet weak var noReplyLabel : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var feedBank : FeedDataBank!
    var feedRootTweet : FeedData!

    override func viewDidLoad() {
        super.viewDidLoad()
        feedBank = FeedDataBank(rootTweet: feedRootTweet)
        feedBank.delegate = self
        
        //Set up right swipe gesture
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGesture(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableView.automaticDimension;
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func initialiseRootTweet(rootTweet : FeedData){
        feedRootTweet = rootTweet
    }
    
    @objc func swipeRightGesture(_ sender:UISwipeGestureRecognizer){
        if sender.state == .ended{
            feedBank.cleanBank()
            feedBank = nil
            feedRootTweet = nil
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
        var identifier : String = ""
        
        if cellsData.tweetImage != nil {
            identifier = indexPath.row == 0 ? "ReplyFeedRootImageCell" : "ReplyFeedReplyImageCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ReplyFeedImageTableCell
            cell.cellData = cellsData
            cell.setTailBlueLineActive(isActive: indexPath.row != feedBank.usersTweets.count - 1)
            return cell
        }
            
        else{
            identifier = indexPath.row == 0 ? "ReplyFeedRootCell" : "ReplyFeedReplyCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ReplyFeedTableCell
            cell.cellData = cellsData
            cell.setTailBlueLineActive(isActive: indexPath.row != feedBank.usersTweets.count - 1)
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
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        if feedBank.usersTweets.count > 1 {
            self.tableView.isHidden = false
            self.noReplyLabel.isHidden = true
            self.tableView.reloadData()
        }
        else {
            self.tableView.isHidden = true
            self.noReplyLabel.isHidden = false
        }
    }
    
    func updateCellAtIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
