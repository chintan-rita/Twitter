//
//  Tweet.swift
//  Twitter
//
//  Created by Chintan Rita on 9/28/15.
//  Copyright © 2015 Chintan Rita. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var author: User?
    var reTweetAuthor: User?

    var text: String?
    var reTweetCount: Int?
    var favCount: Int?
    var createdAtString: String?
    var createdAt: NSDate?
    var reTweetDetails: NSDictionary?
    var favorited: Bool?
    var reTweeted: Bool?
    var id: String?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        author = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favorited = dictionary["favorited"] as? Bool
        reTweeted = dictionary["retweeted"] as? Bool

        reTweetCount = dictionary["retweet_count"] as? Int
        favCount = dictionary["favorite_count"] as? Int
        
        if (dictionary["retweeted_status"] != nil) {
            let reTweetDictionary = dictionary["retweeted_status"] as! NSDictionary
            text = reTweetDictionary["text"] as? String
            reTweetAuthor = author
            createdAtString = reTweetDictionary["created_at"] as? String
            author = User(dictionary: reTweetDictionary["user"] as! NSDictionary)
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    
}
