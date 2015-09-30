//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Chintan Rita on 9/28/15.
//  Copyright © 2015 Chintan Rita. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var tweetView: UITextView!
        
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var originalColor = UIColor.blackColor()
    var tweet: Tweet!
    var originalText: String!
    
    @IBOutlet weak var remainingCharsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        userScreenNameLabel.text = User.currentUser!.screenName
        userNameLabel.text = User.currentUser!.name
        userProfileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        originalColor = UIColor.grayColor()
        tweetView.textColor = originalColor
        tweetView.layer.borderColor = UIColor.lightGrayColor().CGColor
        tweetView.layer.cornerRadius = 5
        tweetView.layer.borderWidth = 1
        
        if tweet == nil {
            originalText = "enter your tweet here"
            tweetButton.setTitle("Tweet", forState: UIControlState.Normal)
            self.title = "Compose Tweet"
        }
        else {
            originalText = "enter your reply here"
            tweetButton.setTitle("Reply", forState: UIControlState.Normal)
            self.title = "Compose Reply"

        }
        tweetView.text = originalText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text ==  originalText {
            textView.textColor = UIColor.blackColor()
            textView.text = ""
        }
        return true;
    }
    
    func textViewDidChange(textView: UITextView) {
        var remainingLength = 140
        if textView.text == originalText {
            remainingLength = 140
        }
        else {
            remainingLength = 140 - textView.text.characters.count
        }
        
        remainingCharsLabel.text = "\(remainingLength) characters remaining"
    }

    @IBAction func onTweet(sender: AnyObject) {
        if tweet == nil {
            var submitDictionary = [String: String]()
            submitDictionary["status"] = self.tweetView.text
            TwitterClient.sharedInstance.tweet(submitDictionary) { (tweet, error) -> () in
                if tweet == nil {
                    self.showErrorLabel()
                }
                else {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
        else {
            TwitterClient.sharedInstance.reply(self.tweetView.text, tweet: tweet) { (tweet, error) -> () in
                if tweet == nil {
                    self.showErrorLabel()
                }
                else {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
    }
    
    func showErrorLabel() {
        errorLabel.hidden = false
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "hideErrorLabel", userInfo: nil, repeats: true)
    }
    
    func hideErrorLabel() {
        errorLabel.hidden = true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.textColor = originalColor
            textView.text = originalText
        }
        return true;
    }
    
    func textView(textView: UITextView,  shouldChangeTextInRange range:NSRange, replacementText text:String ) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 140;
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
