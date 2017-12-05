//
//  ProfileViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kelley Lu Chen. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Account", message: "R U SURE?!", preferredStyle: .alert)
        
        let deleteBtn = UIAlertAction(title: "Delete", style: .default, handler: {
            check -> Void in
            NSLog("Delete Pressed")
            self.performLogOut()
            self.navigationController?.popToRootViewController(animated: true)
            /*
            self.spinner.startAnimating()
            self.iQuizLabel.text = ""
            let newURL = alert.textFields![0] as UITextField
            self.retrieveData(newURL.text!)
            */
        })
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .default, handler: {_ in NSLog("Cancel Pressed")
            /*
            self.spinner.stopAnimating()
            self.iQuizLabel.text = "iQuiz"
             */
        })

        alert.addAction(deleteBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    private func performLogOut() {
        let prevController = self.navigationController?.viewControllers[0] as! LoginViewController
        prevController.logOut(passedState: false)
    }
    
    @objc func backToList(sender: AnyObject) {
        performLogOut()
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.backToList(sender:)))
        self.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
