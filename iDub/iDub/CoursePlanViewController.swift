//
//  CoursePlanViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 8..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class CoursePlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var planTableView: UITableView!
    @IBOutlet weak var scheduleWindow: UIView!
    @IBOutlet weak var planListBtn: UIButton!
    @IBOutlet weak var timeScheduleBtn: UIButton!
    private var daysofWeek = ["Mon", "Tues", "Wed", "Thurs", "Fri"]
    private var hours = ["08:30", "09:30","10:30","11:30","12:30","13:30","14:30","15:30","16:30","17:30","18:30","19:30","20:30"]
    private var currUser: User = User(userName: "")
    private var plannedClass:[Course] = []
    private var isLoggedIn = true
    
    /////// KELLEY
    private var colors = [UIColor(hue: 0.1361, saturation: 1, brightness: 0.98, alpha: 1.0) /* #f9cc00 */
        , UIColor(hue: 0.2028, saturation: 1, brightness: 0.97, alpha: 1.0) /* #c1f700 */
        , UIColor(hue: 0.3222, saturation: 1, brightness: 0.96, alpha: 1.0) /* #10f400 */
        , UIColor(hue: 0.4528, saturation: 1, brightness: 0.97, alpha: 1.0), /* #00f7b1 */
        UIColor(hue: 0.5333, saturation: 1, brightness: 0.98, alpha: 1.0), /* #00c7f9 */
        UIColor(hue: 0.6389, saturation: 1, brightness: 0.97, alpha: 1.0) /* #0029f7 */
        , UIColor(hue: 0.7583, saturation: 1, brightness: 0.97, alpha: 1.0) /* #8800f7 */
        , UIColor(hue: 0.8694, saturation: 1, brightness: 0.98, alpha: 1.0) /* #f900c3 */
        , UIColor(hue: 0.9806, saturation: 1, brightness: 0.96, alpha: 1.0) /* #f4001c */
    ]
    private var colorIndex = 0

    @IBAction func planListPressed(_ sender: UIButton) {
        scheduleWindow.alpha = 0
        // ADDED: Color scheme for selected btn
        planListBtn.backgroundColor = UIColor.white
        planListBtn.setTitleColor(hexStringToUIColor(hex: "#8362D3"), for: .normal)
        timeScheduleBtn.backgroundColor = hexStringToUIColor(hex: "#E0E0E0")
        timeScheduleBtn.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func timeSchedulePressed(_ sender: UIButton) {
        // ADDED: Color scheme for selected btn
        timeScheduleBtn.backgroundColor = UIColor.white
        timeScheduleBtn.setTitleColor(hexStringToUIColor(hex: "#8362D3"), for: .normal)
        planListBtn.backgroundColor = hexStringToUIColor(hex: "#E0E0E0")
        planListBtn.setTitleColor(UIColor.white, for: .normal)
        
        colorIndex = 0
        performScheduleDisplay()
        // added
        if ((UIApplication.shared.delegate as! AppDelegate).currUser == nil) {
            isLoggedIn = false
        } else {
            currUser = (UIApplication.shared.delegate as! AppDelegate).currUser
        }
        plannedClass = currUser.getClassPlanned()
        
        for planClass in plannedClass {
            displayClass(planClass as! Course)
            colorIndex += 1
        }
        scheduleWindow.alpha = 1
        
    }
    
    // added 2
    private func performScheduleDisplay() {
        scheduleWindow.subviews.forEach({ $0.removeFromSuperview() })
        print("here")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        scheduleWindow.frame.size.width = view.safeAreaLayoutGuide.layoutFrame.size.width
        scheduleWindow.frame.size.height = view.safeAreaLayoutGuide.layoutFrame.size.height - planListBtn.frame.size.height
        scheduleWindow.frame.origin = CGPoint(x: 0, y: planListBtn.frame.size.height + view.safeAreaLayoutGuide.layoutFrame.origin.y)
        let width = scheduleWindow.bounds.size.width / 6
        let height = scheduleWindow.bounds.size.height / 75
        var startX = width
        var oneHour = height * 6
        var hourHeight = height * 3
        // put in hours
        for hour in 0...11 {
            let rect = CGRect(x: 0, y: hourHeight, width: width, height: height * 3) // changed to height * 3
            //                let rect = CGRect(x: , size: CGSize(width: width, height: height))
            let daylabel : UIView = UIView(frame: rect)
            //daylabel.backgroundColor = UIColor(hue: 0.7417, saturation: 0.49, brightness: 0.97, alpha: 1.0) /* #b47ef7 */
            daylabel.backgroundColor = UIColor.white
            daylabel.alpha = 1 //KELLEY
            let day = UILabel(frame: CGRect(x: 0, y: 0, width: daylabel.bounds.size.width, height: daylabel.bounds.size.height))
            day.text = hours[hour]
            [day .sizeToFit()]
            day.textAlignment = .center
            daylabel.addSubview(day)
            daylabel.layer.cornerRadius = 5;
            scheduleWindow.addSubview(daylabel)
            scheduleWindow.alpha = 1
            hourHeight = hourHeight + oneHour
        }
        var currW = width
        for weekd in 0...4 {
            let rect = CGRect(x: currW, y: 0, width: width, height: height * 3)
            //                let rect = CGRect(x: , size: CGSize(width: width, height: height))
            let daylabel : UIView = UIView(frame: rect)
            //daylabel.backgroundColor = UIColor(hue: 0.7417, saturation: 0.49, brightness: 0.97, alpha: 1.0) /* #b47ef7 */
            daylabel.backgroundColor = UIColor.white
            daylabel.alpha=1 // KELLEY
            let day = UILabel(frame: CGRect(x: 0, y: 0, width: daylabel.bounds.size.width, height: daylabel.bounds.size.height))
            day.text = daysofWeek[weekd]
            day.textAlignment = .center
            daylabel.addSubview(day)
            
            daylabel.layer.cornerRadius = 5;
            daylabel.layer.masksToBounds = true;
            scheduleWindow.addSubview(daylabel)
            currW = currW + width
        }
    }
    
    // added 2
    private func displayClass(_ tempClass: Course) {
        let width = scheduleWindow.bounds.size.width / 6
        let height = scheduleWindow.bounds.size.height / 75
        let dates = tempClass.getMeetingDate()
        var i = 0
        var startX = width
        
        for index in dates.characters.indices {
            // Add time schedule in if exists
            if (dates[index] != " ") {
                //                var startY = CGFloat(findTimeDiff("8:30", "8:40")) * height
                var startDiff = findTimeDiff("8:30", tempClass.getStartTime())
                var startY = CGFloat(height)
                if (startDiff == 0) {
                    startY = height * 3
                } else {
                    startY = (CGFloat(startDiff) - 3) * height
                }
                let duration = CGFloat(findTimeDiff(tempClass.getStartTime(), tempClass.getEndTime()))
//                var classHeight = height * duration
//                if (startY + (height * duration) >= scheduleWindow.bounds.size.height) {
//                    classHeight = scheduleWindow.bounds.size.height
//                }
                let rect = CGRect(x: startX, y: startY, width: width, height: height * duration)
                //                let rect = CGRect(x: , size: CGSize(width: width, height: height))
                let testView : UIView = UIView(frame: rect)
                testView.backgroundColor = colors[colorIndex] //KELLEYYYY
                testView.alpha=0.5
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height * duration))
                label.text = "\(tempClass.getAbbr())\(tempClass.getCourseNumber())"
                label.textAlignment = .center
                label .adjustsFontSizeToFitWidth = true
                testView.addSubview(label)
                scheduleWindow.addSubview(testView)
                scheduleWindow.alpha = 1
            }
            startX = startX + width
            i = i + 1
            
        }
        
    }
    
    // added
    func findTimeDiff(_ start: String, _ end: String) -> Int{
        var strt = start
        var nd = end
        if (start == "" || end == "") {
            return 0
        }
        if (strt.characters.first == "0") {
            strt = replace(myString: strt, 0, " ")
        } else if (nd.characters.first == "0") {
            nd = replace(myString: nd, 0, " ")
        }
        if (strt == nd) {
            return 0
        }
        let comp = strt.components(separatedBy: ":")
        var first = comp[0]
        var hour = Int(first)
        let second = comp[1]
        var min = Int(second)
        var curr = "\(hour!):\(min!)"
        var count = 0
        while (curr != nd) {
            min = min! + 10
            count = count + 1
            if (min == 60) {
                min = 0
                hour = hour! + 1
            }
            curr = "\(hour!):\(min!)"
            if (min == 0) {
                curr = "\(curr)0"
            }
        }
        return count
    }
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString.characters)     // gets an array of characters
        chars.remove(at: index)
        //chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            print("Delete button tapped")
            if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
                //(UIApplication.shared.delegate as! AppDelegate).currUser.addCoursePlanned(self.chosenMaj.getCourses()[editActionsForRowAt.row])
                (UIApplication.shared.delegate as! AppDelegate).currUser.removeCoursePlanned((UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned()[index.row])
                self.planTableView.beginUpdates()
                self.planTableView.deleteRows(at: [index], with: .fade)
                self.planTableView.endUpdates()
                let usersNow = (UIApplication.shared.delegate as! AppDelegate).users
                let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
                DispatchQueue.global(qos: .utility).async {
                    self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
                    DispatchQueue.main.async {
                        print("writing is done")
                        //dump((UIApplication.shared.delegate as! AppDelegate).currUser)
                    }
                }
            } else {
                self.tabBarController?.selectedIndex = 2
            }
        }
        delete.backgroundColor = .red
        
        let completed = UITableViewRowAction(style: .normal, title: "Completed") { action, index in
            print("Complete button tapped")
            if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
                (UIApplication.shared.delegate as! AppDelegate).currUser.addCourseTaken((UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned()[index.row])
                (UIApplication.shared.delegate as! AppDelegate).currUser.removeCoursePlanned((UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned()[index.row])
                self.planTableView.beginUpdates()
                //var updatedCourses = (UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned()
                //updatedCourses.remove(at: index.row)
                //self.modifiedMaj.setCourses(newCourses: updatedCourses)
                self.planTableView.deleteRows(at: [index], with: .left)
                self.planTableView.endUpdates()
                
                let usersNow = (UIApplication.shared.delegate as! AppDelegate).users
                let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
                DispatchQueue.global(qos: .utility).async {
                    self.writeUserToDisk(usersNow, self.targetIndexToString(tIndex))
                    DispatchQueue.main.async {
                        print("writing is done")
                    }
                }
            } else {
                self.tabBarController?.selectedIndex = 2
            }
        }
        completed.backgroundColor = .blue
        
        return [delete, completed]
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CourseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CourseTableViewCell
        let plannedC = (UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned()
        //dump(plannedC)
        cell.sectionNumLabel?.text = "\(plannedC[indexPath.row].getAbbr()) \(plannedC[indexPath.row].getCourseNumber()) \(plannedC[indexPath.row].getSectionID())"
        cell.courseNameLabel?.text = plannedC[indexPath.row].getCourseTitleLong()
        
        var capContent = "\(plannedC[indexPath.row].getCurrentEnrollment()) / "
        if (plannedC[indexPath.row].getRoomCapacity() == 0) {
            capContent = "\(capContent)-"
        } else {
            capContent = "\(capContent)\(plannedC[indexPath.row].getRoomCapacity())"
        }
        cell.snlLabel?.text = "\(plannedC[indexPath.row].getSLN())"
        cell.capLabel?.text = "\(capContent)"
        if (isLoggedIn) {
            cell.colorBlock?.backgroundColor = self.colorCell(plannedC[indexPath.row])
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((UIApplication.shared.delegate as! AppDelegate).currUser?.getClassPlanned().count == nil) {
            return 0
        }
        return (UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailPageSegue2", sender: (UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned()[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "DetailPageSegue2") {
            let dest = segue.destination as! CourseDetailViewController
            dest.setCourse(sender as! Course, false, self.colorCell(sender as! Course))
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ADDED: color scheme
        planListBtn.backgroundColor = UIColor.white
        planListBtn.setTitleColor(hexStringToUIColor(hex: "#8362D3"), for: .normal)
        timeScheduleBtn.backgroundColor = hexStringToUIColor(hex: "#E0E0E0")
        timeScheduleBtn.setTitleColor(UIColor.white, for: .normal)
        
        // Do any additional setup after loading the view.
        planTableView.delegate = self
        planTableView.dataSource = self
        planTableView.rowHeight = 50.0
        scheduleWindow.alpha = 0
        self.navigationItem.title = "iDub"
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        planListPressed(planListBtn)
        
        let tIndex = (UIApplication.shared.delegate as! AppDelegate).targetIndex
        var usersNow = [User]()
        if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
            usersNow.append(User(userName: (UIApplication.shared.delegate as! AppDelegate).currUser.getUsername()))
            let takenCourses = (UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken()
            let dup = (UIApplication.shared.delegate as! AppDelegate).currUser.planDuplicate
            DispatchQueue.global(qos: .utility).async {
                let readResult = self.getUserFromDisk(self.targetIndexToString(tIndex))
                DispatchQueue.main.async {
                    if (readResult != nil) {
                        (UIApplication.shared.delegate as! AppDelegate).users = readResult!
                        (UIApplication.shared.delegate as! AppDelegate).currUser = (UIApplication.shared.delegate as! AppDelegate).users[self.findCurrUser((UIApplication.shared.delegate as! AppDelegate).currUser.getUsername())]
                        if ((UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned().count != 0) {
                            (UIApplication.shared.delegate as! AppDelegate).currUser.planDuplicate = dup
                        }
                        
                        //dump((UIApplication.shared.delegate as! AppDelegate).currUser)
                    } else {
                        (UIApplication.shared.delegate as! AppDelegate).users = usersNow
                        (UIApplication.shared.delegate as! AppDelegate).currUser = usersNow[0]
                        (UIApplication.shared.delegate as! AppDelegate).currUser.setCourseTaken(takenCourses)
                    }
                    self.planTableView.reloadData()
                }
            }
        } else {
            self.planTableView.reloadData()
        }
    }
    
    // place inside the VC extension
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
