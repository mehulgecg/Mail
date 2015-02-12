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
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }

        let thread = vc.google.threads[indexPath.row] as Thread

        println("THREAD: \(thread)")

        cell?.textLabel?.text = thread.historyId
        cell?.detailTextLabel?.text = thread.threadId
        return cell!
    }
}
