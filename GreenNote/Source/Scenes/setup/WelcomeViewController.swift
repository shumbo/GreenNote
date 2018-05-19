//
//  WelcomeViewController.swift
//  GreenNote
//
//  Created by Shun Kashiwa on 2018/05/18.
//  Copyright © 2018 Shun Kashiwa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "signup" {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.viewControllers.first as? LoginViewController else { return }
            vc.mode = .SIGNUP
        }
        if segue.identifier == "signin" {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.viewControllers.first as? LoginViewController else { return }
            vc.mode = .SIGNIN
        }
    }

}
