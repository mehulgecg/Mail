//
//  InboxView.swift
//  Mail
//
//  Created by Sapan Bhuta on 2/12/15.
//  Copyright (c) 2015 SapanBhuta. All rights reserved.
//

import UIKit

class InboxView: UIView, UITableViewDelegate, UITableViewDataSource {

    var table: UITableView!
    weak var vc: InboxViewController!

    func setup() {
        vc.title = "Inbox"

        table = UITableView(frame: bounds, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        addSubview(table!)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vc.google.threads.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: NSString = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

        let thread = vc.google.threads[indexPath.row] as Thread
        let latestEmail = thread.emails.lastObject as Email
        cell?.textLabel?.text = latestEmail.from
        cell?.detailTextLabel?.text = latestEmail.subject
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow() as NSIndexPath!
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let threadViewController = ThreadViewController()
        threadViewController.thread = vc.google.threads[indexPath.row] as Thread
        vc.navigationController?.pushViewController(threadViewController, animated: true)
    }
}
