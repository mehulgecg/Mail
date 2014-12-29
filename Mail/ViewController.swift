//
//  ViewController.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let GoogleClientID = "114010924229-ukr4q38c62r7rkoiig6p373n62oeb3j0.apps.googleusercontent.com"
    let GoogleClientSecret = "rAmXi-Eu78US1ST7mI840p9-"
    let GoogleAuthURL = "https://accounts.google.com/o/oauth2/auth"
    let GoogleTokenURL = "https://accounts.google.com/o/oauth2/token"

    override func viewDidLoad() {
        super.viewDidLoad()
        signIntoGoogle()
    }

    func authForGoogle() -> GTMOAuth2Authentication {

        let tokenURL = NSURL(string: GoogleTokenURL)
        let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        var auth: GTMOAuth2Authentication = GTMOAuth2Authentication.authenticationWithServiceProvider("mailmessages", tokenURL: tokenURL, redirectURI: redirectURI, clientID: GoogleClientID, clientSecret: GoogleClientSecret) as GTMOAuth2Authentication
        auth.scope = "https://www.googleapis.com/auth/userinfo.profile"
        return auth
    }

    func signIntoGoogle() {
//        let viewController = GTMOAuth2ViewControllerTouch(authentication: authForGoogle(), authorizationURL: NSURL(string: GoogleAuthURL), keychainItemName: "GoogleKeychainName", delegate: self, finishedSelector: "finished:")


        let viewController = GTMOAuth2ViewControllerTouch(authentication: authForGoogle(), authorizationURL: NSURL(string: GoogleAuthURL), keychainItemName: "GoogleKeychainName", completionHandler: { (viewController: GTMOAuth2ViewControllerTouch!, auth: GTMOAuth2Authentication!, error: NSError!) -> Void in

                println("finished")
                println("auth access token: \(auth.accessToken)")

                //navigationController?.popViewControllerAnimated(false)

                if let err = error {
                    println("FAIL")
                } else {
                    println("WIN")
                }

            })

        navigationController?.presentViewController(viewController, animated: true, completion: nil)
    }
}
