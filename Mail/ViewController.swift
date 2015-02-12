//
//  ViewController.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let google = Google()
    var table: UITableView!
    var emails: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        google.vc = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

//        Google.emails(completion: { (success, result) -> Void in
//            completion(success: success)
//            if success {
//                println("EMAILS: \(result)")
//            } else {
//                UIAlertView(title: "Error", message: "Failed to Get Emails", delegate: nil, cancelButtonTitle: "OK")
//            }
//        })
    }

    func setupTable() {
        table = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        view.addSubview(table!)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: NSString = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }

        let email = emails[0] as Email
        cell?.textLabel?.text = email.subject
        return cell!
    }
}
