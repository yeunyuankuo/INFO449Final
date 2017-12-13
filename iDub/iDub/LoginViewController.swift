//
//  LoginViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

// ADDED: #HEX Color convertion
extension UIViewController {
    //change color to hex#
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                           blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                           alpha: CGFloat(1.0)
        )
    }
}

// ADDED: TextField Style from box to line
extension UITextField {
    func setTextFieldStyle() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class LoginViewController: UIViewController {
    private var currUser: User!
    private var isLoggedIn = false
    func logOut(passedState: Bool) {
        isLoggedIn = passedState
    }
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    // ADDED: new labels and buttons
    @IBOutlet weak var iDub: UILabel!
    @IBOutlet weak var signUpPrompt: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    // ADDED: New function for "Don't have an account" button
    @IBAction func createAccountPress(_ sender: Any) {
        signIn.isHidden = !signIn.isHidden
        signUp.isHidden = !signUp.isHidden
        
        if (signIn.isHidden) {
            signUpPrompt.setTitle("Sign in?", for: .normal)
        } else {
            signUpPrompt.setTitle("Don't have an account?", for: .normal)
        }
        
        errorMessage.text = ""
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        //dump((UIApplication.shared.delegate as! AppDelegate).users)
        errorMessage.text = ""
        let trimmedString = idTextField.text?.trimmingCharacters(in: .whitespaces)
        if (trimmedString != "") {
            if (UIApplication.shared.delegate as! AppDelegate).users.isEmpty { // get user info from AppDelegate
                errorMessage.text = "This account doesn't exist!"
            } else {
                for user in (UIApplication.shared.delegate as! AppDelegate).users {
                    if (idTextField.text == user.getUsername()) {
                        isLoggedIn = true
                        currUser = user
                        performSegue(withIdentifier: "LoginCompleteSegue", sender: sender.title(for: .normal))
                        return
                    }
                }
                errorMessage.text = "This account doesn't exist!"
            }
        } else {
            errorMessage.text = "Please enter a valid account!"
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        // ADDED: update sign in/up button to original state
        signIn.isHidden = false
        signUp.isHidden = true
        
        //dump((UIApplication.shared.delegate as! AppDelegate).users)
        NSLog("Sign up pressed")
        var repeatedUsername = false
        errorMessage.text = ""
        let trimmedString = idTextField.text?.trimmingCharacters(in: .whitespaces)
        if (trimmedString != "") {
            if (UIApplication.shared.delegate as! AppDelegate).users.isEmpty {
                currUser = User(userName: idTextField.text!)
                //users.append(currUser)
                (UIApplication.shared.delegate as! AppDelegate).users.append(currUser)
                let usersNow = (UIApplication.shared.delegate as! AppDelegate).users
                let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
                DispatchQueue.global(qos: .utility).async {
                    self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
                    DispatchQueue.main.async {
                        print("writing is done")
                    }
                }
                performSegue(withIdentifier: "LoginCompleteSegue", sender: sender.title(for: .normal))
            } else {
                for user in (UIApplication.shared.delegate as! AppDelegate).users {
                    if (idTextField.text == user.getUsername()) {
                        //currUser = user
                        repeatedUsername = true
                        errorMessage.text = "This account already exist!"
                    } else {
                        repeatedUsername = false
                    }
                }
                if (!repeatedUsername) {
                    currUser = User(userName: idTextField.text!)
                    (UIApplication.shared.delegate as! AppDelegate).users.append(currUser)
                    let usersNow = (UIApplication.shared.delegate as! AppDelegate).users
                    let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
                    DispatchQueue.global(qos: .utility).async {
                        self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
                        DispatchQueue.main.async {
                            print("writing is done")
                        }
                    }
                    performSegue(withIdentifier: "LoginCompleteSegue", sender: sender.title(for: .normal))
                }
            }
        } else {
            errorMessage.text = "Please enter a valid account!"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginCompleteSegue", let nextScene = segue.destination as? ProfileViewController {
            (UIApplication.shared.delegate as! AppDelegate).currUser = self.currUser
            signUpPrompt.setTitle("Don't have an account?", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // ADDED: login style
        idTextField.setTextFieldStyle()
        iDub.textColor = hexStringToUIColor(hex: "#8362D3")
        signUpPrompt.setTitleColor(hexStringToUIColor(hex: "#8362D3"), for: UIControlState.normal)
        signIn.backgroundColor = hexStringToUIColor(hex: "#8362D3")
        signUp.backgroundColor = hexStringToUIColor(hex: "#8362D3")
        signIn.isHidden = false
        signUp.isHidden = true
        
        // ADDED: nav bar style
        //self.title = "iDub"
        
        // ADDED: tab bar style
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.hideKeyboardWhenTappedAround()

        // ADDED: Tab bar block color
        /*let numberOfItems = CGFloat((tabBarController?.tabBar.items!.count)!)
         let tabBarItemSize = CGSize(width: (tabBarController?.tabBar.frame.width)! / numberOfItems,
         height: (tabBarController?.tabBar.frame.height)!)
         tabBarController?.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: hexStringToUIColor(hex: "#483C7C"),size: tabBarItemSize).resizableImage(withCapInsets: .zero)
         tabBarController?.tabBar.frame.size.width = self.view.frame.width + 4
         tabBarController?.tabBar.frame.origin.x = -2*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
            performSegue(withIdentifier: "LoginCompleteSegue", sender: nil)
        } else {
            let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
            DispatchQueue.global(qos: .utility).async {
                let readResult = self.getUserFromDisk(self.targetIndexToString(tIndex))
                DispatchQueue.main.async {
                    if (readResult != nil) {
                        (UIApplication.shared.delegate as! AppDelegate).users = readResult!
                    }
                }
            }
        }
        /*
        if (isLoggedIn) {
            performSegue(withIdentifier: "LoginCompleteSegue", sender: nil)
        } else {
            var usersNow = [User]()
            let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
            DispatchQueue.global(qos: .utility).async {
                let readResult = self.getMajorFromDisk(self.targetIndexToString(tIndex))
                DispatchQueue.main.async {
                    if (readResult != nil) {
                        (UIApplication.shared.delegate as! AppDelegate).users = readResult!
                    }
                }
            }
 */
            /*
            if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
                usersNow = [User(userName: (UIApplication.shared.delegate as! AppDelegate).currUser.getUsername())]
                let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
                DispatchQueue.global(qos: .utility).async {
                    let readResult = self.getMajorFromDisk(self.targetIndexToString(tIndex))
                    if (readResult == nil) {
                        self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
                        
                    }
                    DispatchQueue.main.async {
                        (UIApplication.shared.delegate as! AppDelegate).users = usersNow
                        if (readResult != nil) {
                            (UIApplication.shared.delegate as! AppDelegate).users = readResult!
                        }
                    }
                }
            }
        }
 */
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
