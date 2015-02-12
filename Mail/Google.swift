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

    weak var vc: ViewController!

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

    func signIn(completion: (success: Bool, auth: GTMOAuth2Authentication) -> Void) {
        let viewController = GTMOAuth2ViewControllerTouch(authentication: authForGoogle(), authorizationURL: NSURL(string: GoogleAuthURL), keychainItemName: GoogleKeychainName) { (viewController: GTMOAuth2ViewControllerTouch!, auth: GTMOAuth2Authentication!, error: NSError!) -> Void in

            println("finished")
            println("auth access token: \(auth.accessToken)")

            viewController.dismissViewControllerAnimated(true, completion: nil)

            if error != nil {
                completion(success: false, auth: auth)
                UIAlertView(title: "Error Authorizing with Google", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                completion(success: true, auth: auth)
                UIAlertView(title: "Success Authorizing with Google", message: "", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
        vc.navigationController?.presentViewController(viewController, animated: true, completion: nil)
    }

    func emails(completion: (success: Bool, result: NSArray) -> Void) {

        signIn { (success, auth) -> Void in
            if success {
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
            } else {
                completion(success: false, result: [])
            }
        }
    }
}
