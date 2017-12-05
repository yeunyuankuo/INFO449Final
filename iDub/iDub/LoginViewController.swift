//
//  LoginViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kelley Lu Chen. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {
    private var isLoggedIn = false
    func logOut(passedState: Bool) {
        isLoggedIn = passedState
    }
    @IBOutlet weak var idTextField: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        isLoggedIn = true
        performSegue(withIdentifier: "LoginCompleteSegue", sender: sender.title(for: .normal))
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        NSLog("Sign up pressed")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (isLoggedIn) {
            performSegue(withIdentifier: "LoginCompleteSegue", sender: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
