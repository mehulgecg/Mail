//
//  ViewController.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let GoogleClientID = "114010924229-1gp2fr10fnp6933vp5522fa1megqiqpb.apps.googleusercontent.com"
    let GoogleClientSecret = "-fGFy6eUW55ObueAM1eQtS6e"
    let GoogleAuthURL = "https://accounts.google.com/o/oauth2/auth"
    let GoogleTokenURL = "https://accounts.google.com/o/oauth2/token"
    let GoogleScope = "https://mail.google.com/"
    let GoogleKeychainName = "GoogleKeychainName"

    var auth: GTMOAuth2Authentication?

    var table: UITableView?
    var emails: Array<Email>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        authenticate()

        if auth!.canAuthorize {
            Gmail.emails(auth!, completion: { (success, result) -> Void in
                if success {
                    self.emails = result
                    self.table?.reloadData()
                }
            })
        } else {
            signIntoGoogle()
        }
    }

    func setupTable() {
        emails = []

        table = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        table?.delegate = self
        table?.dataSource = self
        view.addSubview(table!)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: NSString = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }

        let email: Email = emails![0]
        cell?.textLabel?.text = email.subject
        return cell!
    }


    func authForGoogle() -> GTMOAuth2Authentication {

        let tokenURL = NSURL(string: GoogleTokenURL)
        let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        var auth: GTMOAuth2Authentication = GTMOAuth2Authentication.authenticationWithServiceProvider("mailmessages", tokenURL: tokenURL, redirectURI: redirectURI, clientID: GoogleClientID, clientSecret: GoogleClientSecret) as GTMOAuth2Authentication
        auth.scope = GoogleScope
        return auth
    }

    func signIntoGoogle() {

        let viewController = GTMOAuth2ViewControllerTouch(scope: GoogleScope, clientID: GoogleClientID, clientSecret: GoogleClientSecret, keychainItemName: GoogleKeychainName) { (viewController: GTMOAuth2ViewControllerTouch!, auth: GTMOAuth2Authentication!, error: NSError!) -> Void in

            if error == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
                //handle error
            }
        }

        navigationController?.presentViewController(viewController, animated: true, completion: nil)
    }

    func authenticate() {
        auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(GoogleKeychainName, clientID: GoogleClientID, clientSecret: GoogleClientID)
    }
}
