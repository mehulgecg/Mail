//
//  ViewController.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let GoogleClientID = "114010924229-ukr4q38c62r7rkoiig6p373n62oeb3j0.apps.googleusercontent.com"
    let GoogleClientSecret = "rAmXi-Eu78US1ST7mI840p9-"
    let GoogleAuthURL = "https://accounts.google.com/o/oauth2/auth"
    let GoogleTokenURL = "https://accounts.google.com/o/oauth2/token"

    var table: UITableView?
    var emails: Array<Email>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let token = token() {
            Gmail.emails(token, completion: { (success, result) -> Void in
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
        auth.scope = "https://www.googleapis.com/auth/userinfo.profile"
        return auth
    }

    func signIntoGoogle() {

        let viewController = GTMOAuth2ViewControllerTouch(authentication: authForGoogle(), authorizationURL: NSURL(string: GoogleAuthURL), keychainItemName: "GoogleKeychainName", completionHandler: { (viewController: GTMOAuth2ViewControllerTouch!, auth: GTMOAuth2Authentication!, error: NSError!) -> Void in

                println("finished")
                println("auth access token: \(auth.accessToken)")

                self.saveToken(auth.accessToken)
                self.dismissViewControllerAnimated(true, completion: nil)

                if let err = error {
                    println("FAIL")
                } else {
                    println("WIN")
                }

            })

        navigationController?.presentViewController(viewController, animated: true, completion: nil)
    }

    func saveToken(token: String) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "auth")
    }

    func token() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey("auth") as String?
    }
}
