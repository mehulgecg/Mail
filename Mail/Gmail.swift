//
//  Gmail.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class Gmail: NSObject {

    class func emails(auth: GTMOAuth2Authentication, completion: (success: Bool, result: Array<Email>) -> Void) {

        var emails: Array<Email> = []

        let url = NSURL(string: "https://www.googleapis.com/gmail/v1/users/me/messages")
        let request = NSURLRequest(URL: url!)
        let fetcher = GTMHTTPFetcher(request: request)
        auth.shouldAuthorizeAllRequests = true
        fetcher.authorizer = auth
        fetcher.beginFetchWithCompletionHandler { (data: NSData!, error: NSError!) -> Void in
            if error == nil {

                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println("JSON: \(json)")

                //turn results into Email objects
                //load into an array calles emails
                completion(success: true, result: emails)
            } else {
                println("ERROR: \(error)")
                completion(success: false, result: emails)
            }
        }
    }
}
