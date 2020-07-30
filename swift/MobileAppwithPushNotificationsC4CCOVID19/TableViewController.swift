//
//  TableViewController.swift
//  MobileAppwithPushNotificationsC4CCOVID19
//
//  Created by Watanabe Kentaro on 2020/07/23.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

var Status = "undefined"


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    // UITableView, numberOfRowsInSectionの追加(表示するCell数を決める)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 戻り値の設定(表示するcell数)
        return Messages.count
    }
    
    // UITableView, cellForRowAtの追加(表示するcellの中身を決める)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MessageCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for:indexPath)
        MessageCell.textLabel!.text = Messages[indexPath.row]
        MessageCell.textLabel?.numberOfLines=0
        return MessageCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        UserDefaults.standard.addObserver(self, forKeyPath: "Messages", options: .new, context: nil)
        */
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)

        
        if UserDefaults.standard.object(forKey: "Messages") != nil {
            Messages = UserDefaults.standard.object(forKey: "Messages") as! [String]
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @objc func userDefaultsDidChange(_ notification: Notification) {
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
