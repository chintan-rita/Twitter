//
//  TwitterClient.swift
//  Twitter
//
//  Created by Chintan Rita on 9/28/15.
//  Copyright © 2015 Chintan Rita. All rights reserved.
//

import UIKit


let twitterConsumerKey = "BcZFpwNrMSnAZ817Izsy6qhkh"
let twitterConsumerSecret = "1P7JZNizPUstnBbBJIh8wR9473cwwTSZEgZ4iBOn841VeWcghP"
let twitterURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch my request token and redirect to authorization page
        let twitterInstance = TwitterClient.sharedInstance
        twitterInstance.requestSerializer.removeAccessToken()
        
        twitterInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (answer) -> Void in
            print("Got Request Token: \(answer)")
            let requestToken = answer as BDBOAuth1Credential
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authUrl!)
            }) { (error) -> Void in
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func tweet(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation, response) -> Void in
            print("Tweet Posted")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation, error) -> Void in
            print("Tweet Post Error")
            completion(tweet: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation, response) -> Void in
            print("Fetched homeline")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation, error) -> Void in
            print("Failed to get tweets \(error)")
            completion(tweets: nil, error: error)
        })
    }

    func retweet(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()){
        POST("1.1/statuses/retweet/\(tweet.id!).json", parameters: nil, success: { (opertion:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("successfully retweeted")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error retweeting")
                completion(tweet: nil, error: error)
        }
    }
    
    func reply(reply: String, tweet: Tweet){
        var params = [String: String]()
        params["status"] = reply
        params["in_reply_to_status_id"] = tweet.id
        
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("successfully replied")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error replying")
        }
    }
    
    func favorite(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()){
        POST("1.1/favorites/create.json?id=\(tweet.id!)", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("successfully favorited")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error favoriting")
                completion(tweet: nil, error: error)
        }
    }
    
    func openURL (url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (answer) -> Void in
            print("Got access token \(answer)")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(answer)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation, response) -> Void in
                print("Fetched User")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation, error) -> Void in
                print("Failed to get user credentials")
                self.loginCompletion?(user: nil, error: error)
            })
        }) { (error) -> Void in
            print("Failed to get access token \(error)")
        }

    }
}
