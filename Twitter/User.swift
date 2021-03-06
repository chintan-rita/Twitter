//
//  User.swift
//  Twitter
//
//  Created by Chintan Rita on 9/28/15.
//  Copyright © 2015 Chintan Rita. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUser"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagLine: String?
    var dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().dataForKey(currentUserKey)
                if data != nil {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                    NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                let data = try! NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions())
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
