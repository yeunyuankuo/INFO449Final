//
//  ProfileViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    // File Delete Operation //////////
    
    @IBOutlet weak var removeFilesBtn: UIButton!
    private var isRemoving = false
    @IBAction func removeFilesPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Files", message: "Do you want delete all the files?", preferredStyle: .alert)
        
        let deleteBtn = UIAlertAction(title: "Delete", style: .default, handler: {
            check -> Void in
            NSLog("Delete Pressed")
            

            self.removeFiles()
            
        })
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .default, handler: {_ in NSLog("Cancel Pressed")
            
        })
        
        alert.addAction(deleteBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    private func removeFiles() {
        isRemoving = true
        
        let y = (UIApplication.shared.delegate as! AppDelegate).availableYears
        let q = (UIApplication.shared.delegate as! AppDelegate).quarter
        
        do {
            let fileDest = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Users.json")
            print(fileDest)
            try FileManager.default.removeItem(at: fileDest)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        for i in 0...3 {
            for j in 0...3 {
                DispatchQueue.global(qos: .utility).async {
                    do {
                        let fileDest = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(y[i])\(q[j]).json")
                        try FileManager.default.removeItem(at: fileDest)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    
                    do {
                        let fileDest = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(y[i])\(q[j])Users.json")
                        try FileManager.default.removeItem(at: fileDest)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    DispatchQueue.main.async {
                        self.ableButtons()
                        self.isRemoving = false
                        //let prevController = self.navigationController?.viewControllers[1] as! LoginViewController
                        //prevController.logOut(passedState: false)
                        (UIApplication.shared.delegate as! AppDelegate).currUser = nil
                        (UIApplication.shared.delegate as! AppDelegate).users = [User]()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
        
    }
    
    
    ///////////////////////////////////
    
    
    @IBOutlet weak var usernameID: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var courseList: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var cListScrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    
    private var isEditingProfile = false
    private var prevBtnCount = 0
    private var toBeRemoved = [Int]()
    
    var usernameMode = false
    var majorMode = false
    var yearMode = false
    @IBAction func editProfile(_ sender: UIButton) {
        // ADDED: CHANGE EDIT BG COLOR
        view.backgroundColor = hexStringToUIColor(hex: "#D1D3D4")
        
        isEditingProfile = !isEditingProfile
        if (isEditingProfile) {
            
            // remove File op ////////
            removeFilesBtn.alpha = 1
            isRemoving = false
            //////////////////////////
            
            
            
            
            // ADDED: Use image for edit
            editBtn.setImage(UIImage(named: "close18.png"), for: .normal)
            //editBtn.setTitle("Done", for: .normal)
            
            if (major.text == "") {
                majorTextField.placeholder = "enter major..."
            } else {
                majorTextField.text = major.text
            }
            if (year.text == "") {
                yearTextField.placeholder = "enter year..."
            } else {
                yearTextField.text = year.text
            }
            disableButtons()
            formatCompletedButtons()
            
            usernameTextField.text = usernameID.text
            usernameTextField.isHidden = false
            majorTextField.isHidden = false
            yearTextField.isHidden = false
            usernameID.alpha = 0
            major.alpha = 0
            year.alpha = 0
        } else {
            if (isRemoving) {
                return
            }
            // remove File op ////////
            removeFilesBtn.alpha = 0
            //////////////////////////
            
            // ADDED: Use image for edit
            editBtn.setImage(UIImage(named: "edit25.png"), for: .normal)
            view.backgroundColor = hexStringToUIColor(hex: "#FFFFFF")
            //editBtn.setTitle("Edit", for: .normal)
            
            ableButtons()
            let index = findCurrUser((usernameTextField.text?.trimmingCharacters(in: .whitespaces))!)
            let indexPrev = findCurrUser(usernameID.text!)
            if (index == -1) {
                if (usernameTextField.text != "" && usernameTextField.text?.trimmingCharacters(in: .whitespaces) != "") {
                    usernameID.text = usernameTextField.text?.trimmingCharacters(in: .whitespaces)
                    
                    (UIApplication.shared.delegate as! AppDelegate).users[indexPrev].setUsername(username: (usernameTextField.text?.trimmingCharacters(in: .whitespaces))!)
                }
            }

            if (yearTextField.text != "" && yearTextField.text?.trimmingCharacters(in: .whitespaces) != "") {
                year.text = yearTextField.text
                (UIApplication.shared.delegate as! AppDelegate).users[indexPrev].setYear(year: (yearTextField.text?.trimmingCharacters(in: .whitespaces))!)
            }

            if (majorTextField.text != "" && majorTextField.text?.trimmingCharacters(in: .whitespaces) != "") {
                major.text = majorTextField.text
                (UIApplication.shared.delegate as! AppDelegate).users[indexPrev].setMajor(major: (majorTextField.text?.trimmingCharacters(in: .whitespaces))!)
            }

            if (index != -1) {
                (UIApplication.shared.delegate as! AppDelegate).users[index].setYear(year: yearTextField.text!)
                (UIApplication.shared.delegate as! AppDelegate).users[index].setMajor(major: majorTextField.text!)
            }


            toBeRemoved.sort()
            toBeRemoved.reverse()
            
            for i in toBeRemoved {
                (UIApplication.shared.delegate as! AppDelegate).currUser.removeCourseTaken((UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken()[i - 1])
            }
            layoutCourseList()
            toBeRemoved.removeAll()
            let usersNow = (UIApplication.shared.delegate as! AppDelegate).users
            let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
            DispatchQueue.global(qos: .utility).async {
                self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
                DispatchQueue.main.async {
                    print("writing is done")
                }
            }

            reformatCompletedButtons()
            usernameTextField.isHidden = true
            majorTextField.isHidden = true
            yearTextField.isHidden = true
            usernameID.alpha = 1
            major.alpha = 1
            year.alpha = 1
        }
    }
    
    private func reformatCompletedButtons() {
        for i in 1...prevBtnCount + 1 {
            if let viewWithTag = self.buttonView.viewWithTag(i) {
                let btn = viewWithTag as! UIButton
                dump(btn)
                let courseName = "\(btn.titleLabel?.text ?? "Error")"
                btn.setTitle(courseName, for: .normal)
            }
        }
    }
    
    private func formatCompletedButtons() {
        for i in 1...prevBtnCount + 1 {
            if let viewWithTag = self.buttonView.viewWithTag(i) {
                let btn = viewWithTag as! UIButton
                dump(btn)
                let courseName = "\(btn.titleLabel?.text ?? "Error")   X"
                btn.setTitle(courseName, for: .normal)
            }
        }
    }
    
    private func disableButtons() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        deleteBtn.isEnabled = false
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            tabArray[0].isEnabled = false
            tabArray[1].isEnabled = false
            tabArray[2].isEnabled = false
        }
    }
    
    private func ableButtons() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        deleteBtn.isEnabled = true

        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            tabArray[0].isEnabled = true
            tabArray[1].isEnabled = true
            tabArray[2].isEnabled = true
        }
    }
    
    private func findCurrUser(_ uid: String) -> Int {
        var index = -1
        for curr in (UIApplication.shared.delegate as! AppDelegate).users {
            index += 1;
            if (curr.getUsername() == uid) {
                return index
            }
        }
        return -1
    }
    
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Account", message: "R U SURE?!", preferredStyle: .alert)
        
        let deleteBtn = UIAlertAction(title: "Delete", style: .default, handler: {
            check -> Void in
            NSLog("Delete Pressed")
            
            let index = self.findCurrUser(self.usernameID.text!)
            if (index != -1) {
                (UIApplication.shared.delegate as! AppDelegate).users.remove(at: index)
                let usersNow = (UIApplication.shared.delegate as! AppDelegate).users
                let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
                DispatchQueue.global(qos: .utility).async {
                    self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
                    DispatchQueue.main.async {
                        print("writing is done")
                    }
                }
            }
            //dump((UIApplication.shared.delegate as! AppDelegate).users)
            self.performLogOut()

        })
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .default, handler: {_ in NSLog("Cancel Pressed")

        })
        
        alert.addAction(deleteBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    private func performLogOut() {
        let prevController = self.navigationController?.viewControllers[0] as! LoginViewController
        prevController.logOut(passedState: false)
        let usersNow = (UIApplication.shared.delegate as! AppDelegate).users
        let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
        self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
        print("writing is done")
        (UIApplication.shared.delegate as! AppDelegate).currUser = nil
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        readingFileUpdate()
    }

    private func readingFileUpdate() {
        let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
        DispatchQueue.global(qos: .utility).async {
            let readResult = self.getUserFromDisk(self.targetIndexToString(tIndex))
            DispatchQueue.main.async {
                if (readResult != nil) {
                    (UIApplication.shared.delegate as! AppDelegate).users = readResult!
                }
                /*
                let userIndex = self.findCurrUser((UIApplication.shared.delegate as! AppDelegate).currUser.getUsername())
                if (userIndex != -1) {
                    (UIApplication.shared.delegate as! AppDelegate).currUser = (UIApplication.shared.delegate as! AppDelegate).users[userIndex]
                    dump((UIApplication.shared.delegate as! AppDelegate).currUser)
                }
 */
            }
        }
    }
    
    @objc func backToList(sender: AnyObject) {
        performLogOut()
    }
 
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func courseListView(_ buttonSize:CGSize, _ buttonCount:Int, _ paddingX: Int) -> UIView  {
        self.buttonView.frame = self.cListScrollView.bounds
        self.buttonView.isUserInteractionEnabled = true
        let padding = CGSize(width: paddingX, height: paddingY)
        buttonView.frame.size.height = (buttonSize.height + padding.height) * CGFloat(buttonCount / 3 + 1)
        let startingPosition = CGPoint(x: padding.width * 0.5, y: padding.height * 0.5)
        var buttonPosition = startingPosition
        let buttonXIncrement = buttonSize.width + padding.width
        let buttonYIncrement = buttonSize.height + padding.height
        var returnIndex = 1
        for i in 0...(buttonCount - 1)  {
            var button = UIButton(type: .custom)
            button.frame.size = buttonSize
            button.frame.origin = buttonPosition
            
            if (returnIndex == 3) {
                buttonPosition.y = buttonPosition.y + buttonYIncrement
                buttonPosition.x = startingPosition.x
            } else {
                buttonPosition.x = buttonPosition.x + buttonXIncrement
            }

            if (returnIndex == 3) {
                returnIndex = 1
            } else {
                returnIndex += 1
            }
            
            let sectionTitle = "\((UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken()[i].getAbbr()) \((UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken()[i].getCourseNumber())"
            button.setTitle(sectionTitle, for: .normal)
            button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 10)
            button.tag = i + 1
            button.addTarget(self, action: #selector(self.courseListClicked(sender:)), for: .touchUpInside)
            button.backgroundColor = UIColor.lightGray
            buttonView.addSubview(button)
        }
        prevBtnCount = buttonCount
        return buttonView
    }
    
    @objc func courseListClicked(sender:UIButton){
        if (isEditingProfile) {
            self.buttonView.viewWithTag(sender.tag)?.removeFromSuperview()
            toBeRemoved.append(sender.tag)
            prevBtnCount -= 1
        } else {
            // Nothing happens
        }
    }

    private let buttonView = UIView()
    //private let paddingX = 14
    private let paddingY = 14
    private let btnHeight: CGFloat = 20
    
    private func placeCourseList() {
        if ((UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken().count != 0) {
            let padX = (cListScrollView.frame.size.width / 5) / 3
            let widthBtn = (cListScrollView.frame.size.width - CGFloat(padX * 3)) / 3
            let scrollingView = courseListView(CGSize(width: widthBtn, height: btnHeight), (UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken().count, Int(padX))
            cListScrollView.contentSize = scrollingView.frame.size
            cListScrollView.addSubview(scrollingView)
            cListScrollView.showsVerticalScrollIndicator = true
            cListScrollView.delegate = self
            cListScrollView.isPagingEnabled = true
            cListScrollView.indicatorStyle = .default
            cListScrollView.canCancelContentTouches = true
            cListScrollView.delaysContentTouches = true
            cListScrollView.isExclusiveTouch = true
        }
    }
    
    private func removeBtns() {
        for i in 1...prevBtnCount + 1 {
            if let viewWithTag = self.buttonView.viewWithTag(i) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    private func layoutCourseList() {
        if (prevBtnCount != 0) {
            removeBtns()
        }
        placeCourseList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
        var usersNow = [User(userName: (UIApplication.shared.delegate as! AppDelegate).currUser.getUsername())]
        let takenCourses = (UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken()
        DispatchQueue.global(qos: .utility).async {
            let readResult = self.getUserFromDisk(self.targetIndexToString(tIndex))
            if (readResult == nil) {
                usersNow[0].setCourseTaken(takenCourses)
                self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
            }
            DispatchQueue.main.async {
                if (readResult != nil) {
                    (UIApplication.shared.delegate as! AppDelegate).users = readResult!
                    (UIApplication.shared.delegate as! AppDelegate).users[self.findCurrUser((UIApplication.shared.delegate as! AppDelegate).currUser.getUsername())] = (UIApplication.shared.delegate as! AppDelegate).currUser

                } else {
                    (UIApplication.shared.delegate as! AppDelegate).users = usersNow
                    (UIApplication.shared.delegate as! AppDelegate).currUser = usersNow[0]
                }
                self.layoutCourseList()
            }
        }
    }
    
    @objc func rotated() {
        layoutCourseList()
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        removeFilesBtn.alpha = 0        // remove File operation
        self.hideKeyboardWhenTappedAround()

        super.viewDidLoad()
        self.navigationItem.title = "iDub"

        usernameID.text = (UIApplication.shared.delegate as! AppDelegate).currUser.getUsername()

        if ((UIApplication.shared.delegate as! AppDelegate).currUser.getMajor() == "") {
            major.text = "Major"
        } else {
            major.text = (UIApplication.shared.delegate as! AppDelegate).currUser.getMajor()
        }
        
        if ((UIApplication.shared.delegate as! AppDelegate).currUser.getYear() == "") {
            year.text = "Year"
        } else {
            year.text = (UIApplication.shared.delegate as! AppDelegate).currUser.getYear()
        }

        usernameTextField.isHidden = true
        majorTextField.isHidden = true
        yearTextField.isHidden = true
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.backToList(sender:)))
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = round(cListScrollView.contentOffset.x / cListScrollView.frame.size.width)
        print(index)
    }
}
