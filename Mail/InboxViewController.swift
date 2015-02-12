//
//  ViewController.swift
//  Mail
//
//  Created by Sapan Bhuta on 12/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {

    let google = Google()
    var inboxView = InboxView()

    override func viewDidLoad() {
        super.viewDidLoad()

        inboxView.frame = view.bounds
        inboxView.vc = self
        inboxView.setup()
        view.addSubview(inboxView)

        google.vc = self
        google.signIn { (success, error) -> Void in
            if success {
                self.getThreads()
                UIAlertView(title: "Success Authorizing with Google", message: "", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                UIAlertView(title: "Error Authorizing with Google", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func getThreads() {
        google.threads({ (success) -> Void in
            if success {
                var total = self.google.threads.count
                var count = 0
                for thread in self.google.threads {
                    self.google.emailsInThread(thread as Thread, completion: { (success) -> Void in
                        count = count + 1
                        if count == total {
                            self.inboxView.table.reloadData()
                        }
                    })
                }
            } else {
                UIAlertView(title: "Error", message: "Failed to Get Emails", delegate: nil, cancelButtonTitle: "OK").show()
            }
        })
    }
}
