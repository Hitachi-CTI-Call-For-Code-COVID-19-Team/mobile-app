//
//  AddController.swift
//  MobileAppwithPushNotificationsC4CCOVID19
//
//  Created by Watanabe Kentaro on 2020/07/23.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

var Messages = [String]()



class AddController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var MessageTextField: UITextField!
    @IBAction func MessageAddButton(_ sender: Any) {
        Messages.append(MessageTextField.text!)
        MessageTextField.text = ""
        UserDefaults.standard.set(Messages, forKey: "Messages")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        Messages.append(MessageTextField.text!)
        MessageTextField.text = ""
        UserDefaults.standard.set(Messages, forKey: "Messages")
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageTextField.delegate = self
        // Do any additional setup after loading the view.
        
        

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
