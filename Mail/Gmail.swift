//
//  Gmail.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class Gmail: NSObject {

    class func emails(token: String, completion: (result: Array<Email>) -> Void) {

        var emails: Array<Email> = []

        //call gmail api
        //turn results into Email objects
        //load into an array calles emails

        completion(result: emails)
    }
}
