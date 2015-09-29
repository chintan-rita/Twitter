//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Chintan Rita on 9/28/15.
//  Copyright © 2015 Chintan Rita. All rights reserved.
//

import UIKit

protocol TweetCellDelegator {
    func callSegueFromCell(tweet dataobject: Tweet)
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegator {

    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func callSegueFromCell(tweet dataobject: Tweet) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegueWithIdentifier("replySegue", sender:dataobject )
        
    }
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        if User.currentUser != nil {
            fetchTweets()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (TwitterClient.sharedInstance.newTweet != nil) {
            self.tweets?.insert(TwitterClient.sharedInstance.newTweet, atIndex: 0)
            self.tableView.reloadData()
        }
    }
    
    func fetchTweets() {
        JTProgressHUD.show()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.refreshControl.endRefreshing()
            self.tweets = tweets
            self.tableView.reloadData()
            JTProgressHUD.hide()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tweets != nil {
            return tweets!.count
        }
        else{
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetViewCell
        cell.delegate = self
        cell.tweet = self.tweets![indexPath.row]
        return cell
    }
    
    func onReply(sender: AnyObject?) {
        self.performSegueWithIdentifier("replySegue", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "detailViewSegue" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let vc = segue.destinationViewController as! TweetDetailViewController
            vc.tweet = self.tweets![indexPath!.item]
        }
        else if segue.identifier  == "replySegue" {
            let composeVC = segue.destinationViewController as! TweetComposeViewController
            composeVC.tweet = sender as! Tweet
        }
    }
    

}
