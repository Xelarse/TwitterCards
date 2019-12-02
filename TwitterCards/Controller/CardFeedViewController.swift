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

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noTweetsLabel : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var feedBank : FeedDataBank!
    var handles : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedBank = FeedDataBank(initType: .Real, handles: handles)
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
    
    func initHandles(handleArray : [String]){
        handles = handleArray
    }
    
    @objc func swipeRightGesture(_ sender:UISwipeGestureRecognizer){
        if sender.state == .ended{
            let _ = navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - TableView Extensions
extension CardFeedViewController : UITableViewDataSource, UITableViewDelegate{
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellsData = feedBank.usersTweets[indexPath.row]
        
        let replyFeedVC = storyboard?.instantiateViewController(withIdentifier: "ReplyFeedViewController") as! ReplyFeedViewController
        replyFeedVC.initialiseRootTweet(rootTweet: cellsData)
        navigationController?.pushViewController(replyFeedVC, animated: true)
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
extension CardFeedViewController : FeedDataBankDelegate {
    func dataReady() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        if feedBank.usersTweets.count == 0 {
            self.noTweetsLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else{
            self.noTweetsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func updateCellAtIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
