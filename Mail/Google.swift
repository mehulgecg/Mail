//
//  Google.swift
//  Mail
//
//  Created by Sapan Bhuta on 2/11/15.
//  Copyright (c) 2015 SapanBhuta. All rights reserved.
//

import UIKit

class Google: NSObject {
    let GoogleClientID = "114010924229-1gp2fr10fnp6933vp5522fa1megqiqpb.apps.googleusercontent.com"
    let GoogleClientSecret = "-fGFy6eUW55ObueAM1eQtS6e"
    let GoogleAuthURL = "https://accounts.google.com/o/oauth2/auth"
    let GoogleTokenURL = "https://accounts.google.com/o/oauth2/token"
    let GoogleScope = "https://mail.google.com/"
    let GoogleKeychainName = "GoogleKeychainName"
    let GoogleServiceProvider = "mailmessages"

    var auth: GTMOAuth2Authentication!
    weak var vc: UIViewController!

    var threads: NSMutableArray = []

    func savedAuth() -> GTMOAuth2Authentication {
        return GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(GoogleKeychainName, clientID: GoogleClientID, clientSecret: GoogleClientID) as GTMOAuth2Authentication
    }

    func authForGoogle() -> GTMOAuth2Authentication {
        let tokenURL = NSURL(string: GoogleTokenURL)
        let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        let auth = GTMOAuth2Authentication.authenticationWithServiceProvider(GoogleServiceProvider, tokenURL: tokenURL, redirectURI: redirectURI, clientID: GoogleClientID, clientSecret: GoogleClientSecret) as GTMOAuth2Authentication
        auth.scope = GoogleScope
        return auth
    }

    func signIn(completion: (success: Bool, error: NSError!) -> Void) {
        let viewController = GTMOAuth2ViewControllerTouch(authentication: authForGoogle(), authorizationURL: NSURL(string: GoogleAuthURL), keychainItemName: GoogleKeychainName) { (viewController: GTMOAuth2ViewControllerTouch!, auth: GTMOAuth2Authentication!, error: NSError!) -> Void in
            self.auth = auth
            println("finished")
            println("auth access token: \(auth.accessToken)")
            viewController.dismissViewControllerAnimated(true, completion: nil)
            completion(success: error == nil, error: error)
        }
        vc.navigationController?.presentViewController(viewController, animated: true, completion: nil)
    }

    func threads(completion: (success: Bool) -> Void) {
        let url = NSURL(string: "https://www.googleapis.com/gmail/v1/users/me/threads")
        let request = NSURLRequest(URL: url!)
        let fetcher = GTMHTTPFetcher(request: request)
        auth.shouldAuthorizeAllRequests = true
        fetcher.authorizer = auth
        fetcher.beginFetchWithCompletionHandler { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                if json != nil {
                    let threadsDict = (json! as NSDictionary)["threads"] as NSArray
                    for threadDict in threadsDict {
                        self.threads.addObject(Google.threadify(threadDict as NSDictionary))
                    }
                }
                completion(success: true)
            } else {
                println("Error: \(error)")
                completion(success: false)
            }
        }
    }

    func emailsInThread(thread: Thread, completion: (success: Bool) -> Void) {
        let url = NSURL(string: ("https://www.googleapis.com/gmail/v1/users/me/threads/"+thread.threadId))
        let request = NSURLRequest(URL: url!)
        let fetcher = GTMHTTPFetcher(request: request)
        auth.shouldAuthorizeAllRequests = true
        fetcher.authorizer = auth


        fetcher.beginFetchWithCompletionHandler { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                if json != nil {
                    let emailsArra = (json! as NSDictionary)["messages"] as NSArray
                    thread.emails = Google.emailify(emailsArra)
                    completion(success: true)
                } else {
                    completion(success: false)
                }
            } else {
                println("Error: \(error)")
                completion(success: false)
            }
        }
    }

    class func threadify(threadDict: NSDictionary) -> Thread {
        let thread = Thread()
        thread.threadId = threadDict["id"] as NSString
        thread.historyId = threadDict["historyId"] as NSString
        thread.snippet = threadDict["snippet"] as NSString
        return thread
    }

    class func emailify(emailsArra: NSArray) -> NSMutableArray {
        var emails: NSMutableArray = []
        for emailGenr in emailsArra {
            let emailDict = emailGenr as NSDictionary
            let email = Email()
            email.googleId = emailDict["id"] as NSString
            email.googleThreadId = emailDict["threadId"] as NSString
            email.labelsIds = NSMutableArray(array: emailDict["labelIds"] as NSArray)
            email.snippet = emailDict["snippet"] as NSString
            let payload = emailDict["payload"] as NSDictionary
            let headers = payload["headers"] as NSArray

            for header in headers {
                let name = (header as NSDictionary)["name"] as NSString
                if name.isEqualToString("From") {
                    email.subject = (header as NSDictionary)["value"] as NSString
                } else if name.isEqualToString("Subject") {
                    email.subject = (header as NSDictionary)["value"] as NSString
                } else if name.isEqualToString("To") {
                    email.to = (header as NSDictionary)["value"] as NSString
                }
            }
            emails.addObject(email)
        }

        return emails
    }
}
