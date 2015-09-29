//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Chintan Rita on 9/28/15.
//  Copyright © 2015 Chintan Rita. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    @IBOutlet weak var reTweetAuthor: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var reTweetButton: UIButton!
    @IBOutlet weak var tweetAuthorHandleLabel: UILabel!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetAuthorImageView: UIImageView!
    var tweet: Tweet!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var reTweetCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateView()
    }
    
    func updateView() {
        self.tweetUserNameLabel.text = tweet.author?.name
        self.tweetLabel.text = tweet.text
        self.tweetAuthorHandleLabel.text = tweet.author?.screenName
        self.tweetAuthorImageView.setImageWithURL(NSURL(string: (tweet.author?.profileImageUrl)!))
        self.tweetTimestampLabel.text = tweet.createdAtString
        if (tweet.reTweetAuthor != nil) {
            reTweetAuthor.hidden = false
            let reTweetAuthorname = tweet.reTweetAuthor!.name
            reTweetAuthor.text = "\(reTweetAuthorname!) retweeted"
        }
        else {
            reTweetAuthor.hidden = true
        }
        
        self.favoriteCountLabel.text = "\(tweet!.favCount!)"
        
        self.reTweetCountLabel.text = "\(tweet!.reTweetCount!)"
        
        if (tweet.reTweeted! == true) {
            reTweetButton.setTitle("Retweeted", forState: UIControlState.Normal)
        }
        else {
            reTweetButton.setTitle("Retweet", forState: UIControlState.Normal)
        }
        
        if (tweet.favorited! == true) {
            favoriteButton.setTitle("Favorited", forState: UIControlState.Normal)
        }
        else {
            favoriteButton.setTitle("Favorite", forState: UIControlState.Normal)
        }
        
        replyButton.setTitle("Reply", forState: UIControlState.Normal)
    }

    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(tweet){ (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet
                self.updateView()
            } else {
                
            }
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet){ (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet
                self.updateView()
            } else {
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
