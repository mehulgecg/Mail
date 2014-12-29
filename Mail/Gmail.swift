//
//  Gmail.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class Gmail: NSObject {

    class func emails(token: String, completion: (success: Bool, result: Array<Email>) -> Void) {

        var emails: Array<Email> = []

        let url = "https://www.googleapis.com/gmail/v1/users/me/messages"
        let params = ["token":token]

        var manager = AFHTTPRequestOperationManager()

        manager.GET(url, parameters: params, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            println("SUCCESS")
            println(responseObject)

            //turn results into Email objects
            //load into an array calles emails
            completion(success: true, result: emails)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("FAIL: \(error.localizedDescription)")
            completion(success: false, result: [])
        }

    }
}
