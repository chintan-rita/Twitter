//
//  TweetViewCell.swift
//  Twitter
//
//  Created by Chintan Rita on 9/28/15.
//  Copyright © 2015 Chintan Rita. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var reTweetButton: UIButton!
    @IBOutlet weak var reTweetAuthor: UILabel!
    @IBOutlet weak var tweetAuthorHandleLabel: UILabel!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetAuthorImageView: UIImageView!
    
    var delegate:TweetCellDelegator!
    
    var tweet: Tweet! {
        didSet{
            self.tweetUserNameLabel.text = tweet.author?.name
            self.tweetLabel.text = tweet.text
            self.tweetAuthorHandleLabel.text = tweet.author?.screenName
            self.tweetAuthorImageView.setImageWithURL(NSURL(string: (tweet.author?.profileImageUrl)!))
            self.tweetTimestampLabel.text = self.relativeTimeInString((tweet.createdAt?.timeIntervalSinceNow)!)
            if (tweet.reTweetAuthor != nil) {
                reTweetAuthor.hidden = false
                let reTweetAuthorname = tweet.reTweetAuthor!.name
                reTweetAuthor.text = "\(reTweetAuthorname!) retweeted"
            }
            else {
                reTweetAuthor.hidden = true
            }

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
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(tweet){ (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet
            } else {
                
            }
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet){ (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet
            } else {
                
            }
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(tweet: tweet)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "updateTimeStamp", userInfo: nil, repeats: true)

    }
    
    func updateTimeStamp() {
        self.tweetTimestampLabel.text = self.relativeTimeInString((tweet.createdAt?.timeIntervalSinceNow)!)
    }
    
    func getTimeData(value: NSTimeInterval) -> (count: Int, suffix: String) {
        let count = Int(floor(value))
        let suffix = count != 1 ? "s" : ""
        return (count: count, suffix: suffix)
    }
    
    func relativeTimeInString(value: NSTimeInterval) -> String {
        let value = -value
        switch value {
        case 0...15: return "just now"
            
        case 0..<60:
            let timeData = getTimeData(value)
            return "\(timeData.count)s"
            
        case 0..<3600:
            let timeData = getTimeData(value/60)
            return "\(timeData.count)m"
            
        case 0..<86400:
            let timeData = getTimeData(value/3600)
            return "\(timeData.count)h"
            
        case 0..<604800:
            let timeData = getTimeData(value/86400)
            return "\(timeData.count)d"
            
        default:
            let timeData = getTimeData(value/604800)
            return "\(timeData.count)w"
        }
    }


}
