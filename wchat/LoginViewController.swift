//
//  LoginViewController.swift
//  wchat
//
//  Created by jerry on 2017/3/20.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var serverTF: UITextField!
    @IBOutlet weak var autologinSwitch: UISwitch!
    
    //需要登陆
    var requireLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as! UIBarButtonItem == self.doneButton {
            UserDefaults.standard.setValue(userTF.text, forKey: "WU")
            UserDefaults.standard.setValue(passWordTF.text, forKey: "WPS")
            UserDefaults.standard.setValue(serverTF.text, forKey: "WServer")
            
            //配置自动登陆
            UserDefaults.standard.set(self.autologinSwitch.isOn, forKey: "wxautologin")
            
            //同步用户配置
            UserDefaults.standard.synchronize()
            
            //需要登陆
            requireLogin = true
        }
    }


}
