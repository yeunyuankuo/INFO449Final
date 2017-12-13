//
//  CourseFilterViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class CourseFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var courseTable: UITableView!
    private var chosenMaj: Major = Major(curriculumAbbr: "", curriculumFullName: "", curriculumName: "")
    func setChosenMaj(_ input: Major) {
        chosenMaj = input
    }
    private var modifiedMaj: Major = Major(curriculumAbbr: "", curriculumFullName: "", curriculumName: "")
    private var isLoggedIn = true
    private var currUser: User = User(userName: "")
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .destructive, title: "Add") { action, index in
            print("Add button tapped")
            if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
                //dump((UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned())
                (UIApplication.shared.delegate as! AppDelegate).currUser.addCoursePlanned(self.modifiedMaj.getCourses()[index.row])
                //dump((UIApplication.shared.delegate as! AppDelegate).currUser.getClassPlanned())
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
        add.backgroundColor = .orange
        
        let completed = UITableViewRowAction(style: .normal, title: "Completed") { action, index in
            print("Complete button tapped")
            if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
                (UIApplication.shared.delegate as! AppDelegate).currUser.addCourseTaken(self.modifiedMaj.getCourses()[index.row])
                self.courseTable.beginUpdates()
                var updatedCourses = self.modifiedMaj.getCourses()
                updatedCourses.remove(at: index.row)
                self.modifiedMaj.setCourses(newCourses: updatedCourses)
                self.courseTable.deleteRows(at: [index], with: .left)
                self.courseTable.endUpdates()
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
        
        return [add, completed]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "courseCell")
        let cell:CourseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CourseTableViewCell
        let courses = modifiedMaj.getCourses()
        
        cell.sectionNumLabel?.text = "\(courses[indexPath.row].getAbbr()) \(courses[indexPath.row].getCourseNumber()) \(courses[indexPath.row].getSectionID())"

        cell.courseNameLabel?.text = courses[indexPath.row].getCourseTitleLong()
        
        var capContent = "\(courses[indexPath.row].getCurrentEnrollment()) / "
        if (courses[indexPath.row].getRoomCapacity() == 0) {
            capContent = "\(capContent)-"
        } else {
            capContent = "\(capContent)\(courses[indexPath.row].getRoomCapacity())"
        }
        cell.snlLabel?.text = ""
        cell.capLabel?.text = "\(capContent)"
        if (isLoggedIn) {
            //cell.backgroundColor = colorCell(cell , courses[indexPath.row])
            cell.colorBlock?.backgroundColor = self.colorCell(courses[indexPath.row])
        }
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedMaj.getCourses().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailPageSegue", sender: modifiedMaj.getCourses()[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "DetailPageSegue") {
            let dest = segue.destination as! CourseDetailViewController
            dest.setCourse(sender as! Course, true, self.colorCell(sender as! Course))
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        completeCourseFilter()
        if ((UIApplication.shared.delegate as! AppDelegate).currUser == nil) {
            isLoggedIn = false
        } else {
            currUser = (UIApplication.shared.delegate as! AppDelegate).currUser
        }
        
        self.courseTable.reloadData()
    }
    
    private func completeCourseFilter() {
        modifiedMaj = Major(curriculumAbbr: chosenMaj.getAbbr(), curriculumFullName: chosenMaj.getCurrFullName(), curriculumName: chosenMaj.getCurrName())
        modifiedMaj.setCourses(newCourses: chosenMaj.getCourses())
        if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
            let completedList = (UIApplication.shared.delegate as! AppDelegate).currUser.getClassTaken()
            
            var indexArray = [Int]()
            for eachTakenCourse in completedList {
                if (chosenMaj.getCourseIndex(eachTakenCourse) != -1) {
                    indexArray.append(chosenMaj.getCourseIndex(eachTakenCourse))
                }
            }
            indexArray.sort()
            var numElement = 0
            var newCourses = modifiedMaj.getCourses()
            for each in indexArray {
                newCourses.remove(at: each - numElement)
                numElement += 1
            }
            self.modifiedMaj.setCourses(newCourses: newCourses)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        courseTable.delegate = self
        courseTable.dataSource = self
        courseTable.rowHeight = 70.0
        self.title = "iDub"
        //self.courseTable.register(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
        //self.courseTable.register(CourseTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        self.hideKeyboardWhenTappedAround()

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


extension UIViewController {
    func writeUserToDisk(_ usersNow: [User], _ time: String) {
        do {
            var userDics = [NSDictionary]()
            for each in usersNow {
                userDics.append(each.toJSON())
            }
            let dic = ["users": userDics]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            let jsonURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(time)Users.json")
            try? jsonData.write(to: jsonURL)
            print("done writing to \(jsonURL)")
        } catch {
            print("write to disk failed")
        }
    }
    
    func targetIndexToString(_ input: [Int]) -> String {
        let quarter = ["autumn", "winter", "spring", "summer"]
        let availableYears = [2015, 2016, 2017, 2018]
        if (input[0] < 0) {
            return ""
        }
        return "\(availableYears[input[0]])\(quarter[input[1]])"
    }
    
    func getUserFromDisk(_ input: String) -> [User]? {
        do {
            let jsonURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(input)Users.json")
            let data = try? Data(contentsOf: jsonURL)
            if (data == nil) {
                return nil
            }
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            print("read from disk completed")
            return expandUserJSON(json)
        } catch {
            print("read from disk failed")
            return nil
        }
    }
    
    func expandUserJSON(_ json: NSDictionary) -> [User]? {
        var users = [User]()
        if (json.count != 0) {
            for eachUser in json["users"] as! [Any] {
                var comCourses = [Course]()
                var plnCourses = [Course]()
                let eachUserDic = eachUser as! [String: Any]
                for eachC in eachUserDic["completedCourses"] as! [Any] {
                    var preReq = [Course]()
                    let eachCourseDic = eachC as! [String: Any]
                    for eachPreReq in eachCourseDic["preReq"] as! [Any] {
                        let eachPreReqDic = eachPreReq as! [String: Any]
                        let pCourse = Course(courseNumber: eachPreReqDic["courseNumber"] as! String, courseAbbr: eachPreReqDic["courseAbbr"] as! String)
                        preReq.append(pCourse)
                    }
                    let cCourse = Course(courseNumber: eachCourseDic["courseNumber"] as! String, courseAbbr: eachCourseDic["courseAbbr"] as! String, secID: eachCourseDic["sectionID"] as! String, secHref: eachCourseDic["sectionHref"] as! String)
                    cCourse.set(campus: eachCourseDic["campus"] as! String, courseTitle: eachCourseDic["courseTitle"] as! String, courseTitleLong: eachCourseDic["courseTitleLong"] as! String, courseDesc: eachCourseDic["courseDesc"] as! String, currentEnrollment: eachCourseDic["currentEnrollment"] as! Int, building: eachCourseDic["building"] as! String, roomNum: eachCourseDic["roomNum"] as! String, startTime: eachCourseDic["startTime"] as! String, endTime: eachCourseDic["endTime"] as! String, minCredit: eachCourseDic["minCredit"] as! String, roomCapacity: eachCourseDic["roomCapacity"] as! Int, SLN: eachCourseDic["SLN"] as! String, notes: eachCourseDic["notes"] as! String, meetingDates: eachCourseDic["meetingDates"] as! String)
                    cCourse.setPrereqCourses(preReq)
                    comCourses.append(cCourse)
                }
                
                for eachC in eachUserDic["plannedCourses"] as! [Any] {
                    var preReq = [Course]()
                    let eachCourseDic = eachC as! [String: Any]
                    for eachPreReq in eachCourseDic["preReq"] as! [Any] {
                        let eachPreReqDic = eachPreReq as! [String: Any]
                        let pCourse = Course(courseNumber: eachPreReqDic["courseNumber"] as! String, courseAbbr: eachPreReqDic["courseAbbr"] as! String)
                        preReq.append(pCourse)
                    }
                    let cCourse = Course(courseNumber: eachCourseDic["courseNumber"] as! String, courseAbbr: eachCourseDic["courseAbbr"] as! String, secID: eachCourseDic["sectionID"] as! String, secHref: eachCourseDic["sectionHref"] as! String)
                    cCourse.set(campus: eachCourseDic["campus"] as! String, courseTitle: eachCourseDic["courseTitle"] as! String, courseTitleLong: eachCourseDic["courseTitleLong"] as! String, courseDesc: eachCourseDic["courseDesc"] as! String, currentEnrollment: eachCourseDic["currentEnrollment"] as! Int, building: eachCourseDic["building"] as! String, roomNum: eachCourseDic["roomNum"] as! String, startTime: eachCourseDic["startTime"] as! String, endTime: eachCourseDic["endTime"] as! String, minCredit: eachCourseDic["minCredit"] as! String, roomCapacity: eachCourseDic["roomCapacity"] as! Int, SLN: eachCourseDic["SLN"] as! String, notes: eachCourseDic["notes"] as! String, meetingDates: eachCourseDic["meetingDates"] as! String)
                    cCourse.setPrereqCourses(preReq)
                    plnCourses.append(cCourse)
                }
                
                
                let usr = User(userName: eachUserDic["userName"] as! String, major: eachUserDic["major"] as! String, year: eachUserDic["year"] as! String, plannedCourses: plnCourses, completedCourses: comCourses)
                users.append(usr)
            }
            print("rewrote user delegate")
            return users
        }
        return nil
    }
    
    func colorCell(_ course: Course) -> UIColor {
        var currUser = User(userName: "")
        if ((UIApplication.shared.delegate as! AppDelegate).currUser != nil) {
            currUser = (UIApplication.shared.delegate as! AppDelegate).currUser
        } else {
            return UIColor.white
        }
        if (course.getCurrentEnrollment() >= course.getRoomCapacity()) {
            return hexStringToUIColor(hex: "#FF6666")
        }
        var canTake = true
        for pre in course.getPrereq() {
            let userClass = currUser.getClassTaken() // get completed course
            var tookClass = false
            for taken in userClass {
            if ((pre.getCourseNumber() == taken.getCourseNumber()) && (pre.getCourseAbbr() == taken.getCourseAbbr())) {
                    tookClass = true
                }
            }
            if (!tookClass) {
                canTake = false
                return UIColor(hue: 0.9361, saturation: 0, brightness: 0.86, alpha: 1.0) /* #dbdbdb */
            }
        }
        return UIColor(hue: 0.2528, saturation: 1, brightness: 0.96, alpha: 1.0) /* #77f700 */
    }
}
