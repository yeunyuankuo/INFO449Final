//
//  CourseListViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class CourseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var courseTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var grayView: UIView!
    private let uwURL = "https://ws.admin.washington.edu"
    private var filteredData = [Major]()
    private var isSearching = false
    private var majors = [Major]()
    private var isSuccessful: Bool = true
    private var tableCount = 0
    private let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 150)) // picker size
    
    // added KIWON
    @IBAction func cancelLoading(_ sender: UIButton) {
        isSuccessful = false
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String((UIApplication.shared.delegate as! AppDelegate).availableYears[row])
        } else {
            return (UIApplication.shared.delegate as! AppDelegate).quarter[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var row = pickerView.selectedRow(inComponent: 0)
        
        if component == 0 {
            return (UIApplication.shared.delegate as! AppDelegate).availableYears.count
        } else {
            return (UIApplication.shared.delegate as! AppDelegate).quarter.count
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "courseCell")
        
        if (isSearching) {
            cell.textLabel?.text = filteredData[indexPath.row].getAbbr()
            cell.detailTextLabel?.text = filteredData[indexPath.row].getCurrFullName()
        } else {
            cell.textLabel?.text = majors[indexPath.row].getAbbr()
            cell.detailTextLabel?.text = majors[indexPath.row].getCurrFullName()
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching) {
            tableCount = filteredData.count
            return filteredData.count
        }
        tableCount = majors.count
        return majors.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMaj: Major
        if (!isSearching && tableCount == majors.count) {
            selectedMaj = majors[indexPath.row]
        } else {
            selectedMaj = filteredData[indexPath.row]
        }
        performSegue(withIdentifier: "FilterPageSegue", sender: selectedMaj)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "FilterPageSegue") {
            let dest = segue.destination as! CourseFilterViewController
            //let resultMajor = Major(curriculumAbbr: (sender as! Major).getAbbr(), curriculumFullName: (sender as! Major).getCurrFullName(), curriculumName: (sender as! Major).getCurrName())
            //resultMajor.replaceCourses(newCourses: (sender as! Major).getCourses())
            dest.setChosenMaj((sender as! Major))
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchBar.text == "") {
            isSearching = false
            
            view.endEditing(true)
            courseTable.reloadData()
        } else {
            isSearching = true
            filteredData = majors.filter({$0.getAbbr().lowercased().contains(searchBar.text!.lowercased())})
            courseTable.reloadData()
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIButton) {
        pickerInit()
    }
    
    private func placeTabBars() {
        // ADDED: nav bar style
        self.tabBarController?.tabBar.tintColor = UIColor.white
        let numberOfItems = CGFloat((tabBarController?.tabBar.items!.count)!)
        let tabBarItemSize = CGSize(width: (tabBarController?.tabBar.frame.width)! / numberOfItems,
                                    height: (tabBarController?.tabBar.frame.height)!)
        
        tabBarController?.tabBar.selectionIndicatorImage
            = UIImage.imageWithColor(color: hexStringToUIColor(hex: "#483C7C"),
                                     size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        tabBarController?.tabBar.frame.size.width = self.view.frame.width + 4
        tabBarController?.tabBar.frame.origin.x = -2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "iDub"
        placeTabBars()
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        var hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        
        if (!hasLaunched) {
            pickerInit()
        } else {
            progressBar.alpha = 0
            var isFileStored = false
            if (majors.count <= 1 && (UIApplication.shared.delegate as! AppDelegate).targetIndex[0] >= 0) {
                let y = (UIApplication.shared.delegate as! AppDelegate).availableYears[(UIApplication.shared.delegate as! AppDelegate).targetIndex[0]]
                let q = (UIApplication.shared.delegate as! AppDelegate).availableYears[(UIApplication.shared.delegate as! AppDelegate).targetIndex[1]]
                isFileStored = getMajorFromDisk("\(y)\(q).json")
            } else {
                isFileStored = true
            }
            if (isFileStored) {
                grayView.alpha = 0
                isSuccessful = true
                print("I have the data")
            }
        }

        courseTable.reloadData()
        pickerView.delegate = self
        pickerView.dataSource = self
        courseTable.delegate = self
        courseTable.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        self.courseTable.register(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // new
    private func pickerInit() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 200,height: 150)
        
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Load Data", message: "Reloading may take few minutes", preferredStyle: .alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        
        let checkBtn = UIAlertAction(title: "Load", style: .default, handler: {
            check -> Void in
            let chosenYear = self.pickerView.selectedRow(inComponent: 0)
            let chosenQuarter = self.pickerView.selectedRow(inComponent: 1)
            (UIApplication.shared.delegate as! AppDelegate).targetIndex[0] = chosenYear
            (UIApplication.shared.delegate as! AppDelegate).targetIndex[1] = chosenQuarter
            let isFileStored = self.getMajorFromDisk("\((UIApplication.shared.delegate as! AppDelegate).availableYears[chosenYear])\((UIApplication.shared.delegate as! AppDelegate).quarter[chosenQuarter]).json")
            if (!isFileStored) {
                self.getDataInit("\((UIApplication.shared.delegate as! AppDelegate).availableYears[chosenYear])", (UIApplication.shared.delegate as! AppDelegate).quarter[chosenQuarter])
            } else {
                self.progressBar.alpha = 0
                self.grayView.alpha = 0
            }

        })
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .default, handler: {_ in
            self.progressBar.alpha = 0
            self.grayView.alpha = 0
            
            let hasLaunchedKey = "HasLaunched"
            let defaults = UserDefaults.standard
            var hasLaunched = defaults.bool(forKey: hasLaunchedKey)
            if (self.majors.count <= 1 && !hasLaunched) {
                self.readDefaultData()
            }
        })
        
        editRadiusAlert.addAction(checkBtn)
        editRadiusAlert.addAction(cancelBtn)
        self.present(editRadiusAlert, animated: true)
        (UIApplication.shared.delegate as! AppDelegate).firstTime = false
    }
    
    private func readDefaultData() {
        do {
            let asset = NSDataAsset(name: "InfoList", bundle: Bundle.main)
            let json = try! JSONSerialization.jsonObject(with: asset!.data, options: []) as! NSDictionary
            expandJSON(json)
        } catch {
            print("read from disk failed")
        }
    }
    
    private func getDataInit(_ y: String, _ q: String) {
        grayView.alpha = 0.8
        progressBar.alpha = 1
        progressBar.setProgress(0, animated: true)
        refreshBtn.setTitle("Loading" , for: .normal)
        refreshBtn.isEnabled = false
        //spinner.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            self.getCurr(y, q)
            if (self.isSuccessful) {
                self.getClass(y, q)
            }
            if (self.isSuccessful) {
                self.writeToDisk(y, q)
            }
            
            if (!self.isSuccessful) {
                let alert = UIAlertController(title: "Loading Fail", message: "Try again later", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                    self.isSuccessful = true // added KIWON
                }
            }
            
            DispatchQueue.main.async {
                print("TT")
                self.grayView.alpha = 0
                self.progressBar.alpha = 0
                //self.spinner.stopAnimating()
                self.refreshBtn.setTitle("Refresh" , for: .normal)
                self.refreshBtn.isEnabled = true
                if (!self.isSuccessful) {
                    self.readDefaultData()
                }
                self.courseTable.reloadData()
            }
        }
    }
    
    private func writeToDisk(_ y: String, _ q: String) {
        do {
            var majorDics = [NSDictionary]()
            for each in majors {
                majorDics.append(each.toJSON())
            }
            let dic = ["majors": majorDics]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            let jsonURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(y)\(q).json")
            try? jsonData.write(to: jsonURL)
            print("done writing to \(jsonURL)")
        } catch {
            print("write to disk failed")
        }
    }
    
    private func getMajorFromDisk(_ fileName: String) -> Bool {
        do {
            let jsonURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
            let data = try? Data(contentsOf: jsonURL)
            if (data == nil) {
                return false
            }
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            print("read from disk completed")
            print(jsonURL)
            return expandJSON(json)
        } catch {
            print("read from disk failed")
            return false
        }
    }
    
    private func expandJSON(_ json: NSDictionary) -> Bool {
        var mjrs = [Major]()
        if (json.count != 0) {
            for eachMajor in json["majors"] as! [Any] {
                var courses = [Course]()
                let eachMajorDic = eachMajor as! [String: Any]
                var indexCourse = 0
                var courseIndex = [String: Int]()
                for eachCourse in eachMajorDic["courses"] as! [Any] {
                    var preReq = [Course]()
                    let eachCourseDic = eachCourse as! [String: Any]
                    for eachPreReq in eachCourseDic["preReq"] as! [Any] {
                        let eachPreReqDic = eachPreReq as! [String: Any]
                        let pCourse = Course(courseNumber: eachPreReqDic["courseNumber"] as! String, courseAbbr: eachPreReqDic["courseAbbr"] as! String)
                        preReq.append(pCourse)
                    }
                    let cCourse = Course(courseNumber: eachCourseDic["courseNumber"] as! String, courseAbbr: eachCourseDic["courseAbbr"] as! String, secID: eachCourseDic["sectionID"] as! String, secHref: eachCourseDic["sectionHref"] as! String)
                    cCourse.set(campus: eachCourseDic["campus"] as! String, courseTitle: eachCourseDic["courseTitle"] as! String, courseTitleLong: eachCourseDic["courseTitleLong"] as! String, courseDesc: eachCourseDic["courseDesc"] as! String, currentEnrollment: eachCourseDic["currentEnrollment"] as! Int, building: eachCourseDic["building"] as! String, roomNum: eachCourseDic["roomNum"] as! String, startTime: eachCourseDic["startTime"] as! String, endTime: eachCourseDic["endTime"] as! String, minCredit: eachCourseDic["minCredit"] as! String, roomCapacity: eachCourseDic["roomCapacity"] as! Int, SLN: eachCourseDic["SLN"] as! String, notes: eachCourseDic["notes"] as! String, meetingDates: eachCourseDic["meetingDates"] as! String)
                    courseIndex[eachCourseDic["SLN"] as! String] = indexCourse
                    indexCourse += 1
                    cCourse.setPrereqCourses(preReq)
                    courses.append(cCourse)
                }
                let mjr = Major(curriculumAbbr: eachMajorDic["curriculumAbbr"] as! String,curriculumFullName: eachMajorDic["curriculumFullName"] as! String, curriculumName: eachMajorDic["curriculumName"] as! String)
                mjr.setCourseIndex(courseIndex)
                mjr.setCourses(newCourses: courses)
                mjrs.append(mjr)
            }
            majors = mjrs
            self.courseTable.reloadData()
            return true
        } else {
            print("failed to expand json")
            self.courseTable.reloadData()
            return false
        }
    }
    
    
    
    
    
    
    /// data retreiving
    
    private let KiwonToken = "A78CBA6B-6964-42C2-B832-C54F32A58B1E"
    // Information about the course
    
    private let urlSection = "https://ws.admin.washington.edu/student/v5/course/2017,winter,cse,417/a.json"
    //private let urlCurr = "https://ws.admin.washington.edu/student/v5/curriculum.json?year=2017&quarter=autumn"
    
    private func getCurr(_ y: String, _ q: String) {
        let urlCurr = "https://ws.admin.washington.edu/student/v5/curriculum.json?year=\(y)&quarter=\(q)"
        // change this url to test different resources
        print(urlCurr)
        var request = URLRequest(url: URL(string: urlCurr)!)
        request.httpMethod = "GET"
        
        let access_token = KiwonToken
        //You endpoint is setup as OAUTH 2.0 and we are sending Bearer token in Authorization header
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        let (data, response, error) = URLSession.shared.synchronousDataTask(urlrequest: request)
        if let response = response {
            //NSLog("\(response)")
        }
        if let data = data {
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                self.parseCurriculum(json)
            }
            catch {
                NSLog("\(error)")
                isSuccessful = false
                return
            }
        } else {
            isSuccessful = false
        }
    }

    // Parse the returned list of classes and save it into class objects.
    private func getClass(_ y: String, _ q: String) {
        var index = 0
        for each in self.majors {
            var urlCourses = "https://ws.admin.washington.edu/student/v5/section.json?year=\(y)&quarter=\(q)&curriculum_abbreviation="
            let maj = each
            let abbr = maj.getAbbr()
            let replaced = abbr.replacingOccurrences(of: " ", with: "%20")
            urlCourses = "\(urlCourses)\(replaced)"
            
            var request = URLRequest(url: URL(string: urlCourses)!)
            request.httpMethod = "GET"
            let access_token = self.KiwonToken
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
            let (data, response, error) = URLSession.shared.synchronousDataTask(urlrequest: request)
            if let response = response {
                //NSLog("\(response)")
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    self.parseClasses(json, index)
                    //let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    
                }
                catch {
                    NSLog("\(error)")
                    isSuccessful = false
                    return
                }
            } else {
                isSuccessful = false
            }
            index += 1
            print(index)
            if (!isSuccessful) {
                return
            }
            DispatchQueue.main.async {  // point where we can add tutorials
                let percent = Float(index) / Float(self.majors.count)
                self.progressBar.setProgress(percent, animated: true)
            }
        }
    }
    
    private func getSectionInfo(_ course: Course, _ mjr: Major, _ indexCourse: Int) {
        let destURL = course.getSectionHref()
        let finalURL = "\(uwURL)\(destURL)"
        //print(finalURL)
        
        var request = URLRequest(url: URL(string: finalURL)!)
        request.httpMethod = "GET"
        let access_token = self.KiwonToken
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        let (data, response, error) = URLSession.shared.synchronousDataTask(urlrequest: request)
        if let response = response {
            //NSLog("\(response)")
        }
        if let data = data {
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                self.parseSections(course, json, mjr, indexCourse)
                //let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                
            }
            catch {
                NSLog("\(error)")
                isSuccessful = false
                return
            }
        } else {
            isSuccessful = false
        }
    }
    
    // Parse the curriculum and put information into majors object
    private func parseCurriculum(_ json: NSDictionary) {
        let fields = json["Curricula"] as! NSArray
        for each in fields {
            let abbr = each as! NSDictionary
            let mjr = Major(curriculumAbbr: abbr["CurriculumAbbreviation"] as! String,curriculumFullName: abbr["CurriculumFullName"] as! String, curriculumName: abbr["CurriculumName"] as! String)
            majors.append(mjr)
        }
    }
    
    private func parseClasses(_ json: NSDictionary, _ indx: Int) {
        let mjr = majors[indx]
        var mjrCourses = [Course]()
        let courseJson = json["Sections"] as? NSArray
        if (courseJson != nil) {
            var indexCourse = 0
            for each in courseJson! {
                let cls = each as! NSDictionary
                let course = Course(courseNumber: cls["CourseNumber"] as! String, courseAbbr: cls["CurriculumAbbreviation"] as! String, secID: cls["SectionID"] as! String, secHref: cls["Href"] as! String)
                getSectionInfo(course, mjr, indexCourse)
                mjrCourses.append(course)
                indexCourse += 1
                if (!isSuccessful) {
                    return
                }
            }
            mjr.setCourses(newCourses: mjrCourses)
        }
    }

    private func parsePrereq(_ json: NSDictionary, _ course: Course) {
        if let courseDesc = json["CourseDescription"] as? String {
            if (courseDesc.contains("Major Only")) {
                course.setMajorOnly()
            }
            if (courseDesc.contains("Prerequisite")) {
                var replaced = courseDesc.replacingOccurrences(of: ",", with: "")
                replaced = replaced.replacingOccurrences(of: ".", with: "")
                replaced = replaced.replacingOccurrences(of: ":", with: "")
                replaced = replaced.replacingOccurrences(of: ";", with: "")
                var prereqClasses = [Course]()
                let range = courseDesc.range(of: "Prerequisite")
                let lower = range?.lowerBound
                //let prerqInfo = courseDesc.substring(from: lower!)
                let prerqInfo = String(courseDesc[lower!...])
                let matched = matches (for: "[1-4][0-9]{2}", in: prerqInfo)
                //let separated = prerqInfo.split(separator: " ")
                let separated = replaced.components(separatedBy: " ")
                
                for num in matched {
                    let indx = separated.index(of:num)
                    if (indx != nil) {
                        let prereqClass = Course(courseNumber: num, courseAbbr: separated[indx! - 1])
                        prereqClasses.append(prereqClass)
                    }
                }
                course.setPrereqCourses(prereqClasses)
            }
        }
    }

    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    private func nilFilter(_ input: Any) -> Any {
        if let _ = input as? NSNull {
            return ""
        } else {
            return input
        }
    }
    
    private func parseSections(_ course: Course, _ json: NSDictionary, _ mjr: Major, _ indexCourse: Int) {
        var cap = 0
        if (nilFilter(json["RoomCapacity"]!) as! Int == 0) {
            cap = nilFilter(json["LimitEstimateEnrollment"]!) as! Int
        } else {
            cap = nilFilter(json["RoomCapacity"]!) as! Int
        }
        let meetings = json["Meetings"] as! [[String:Any]]
        let meetingArr = meetings[0] as NSDictionary
        let building = "\(nilFilter(meetingArr["Building"]) as! String)"
        let roomNum = "\(nilFilter(meetingArr["RoomNumber"]) as! String)"
        let start = meetingArr["StartTime"] as! String
        let end = meetingArr["EndTime"] as! String
        //        print(start)
        //        print(end)
        let minCred = json["MinimumTermCredit"] as! String
        let timeSchedComments = json["TimeScheduleComments"] as! NSDictionary
        let sectionComment = timeSchedComments["SectionComments"] as! NSDictionary
        let lines = sectionComment["Lines"] as! [[String: Any]]
        var secComm = ""
        for line in lines {
            secComm = "\(secComm) \(line["Text"] as! String)"
        }
        let TimeScheduleGeneratedComments = timeSchedComments["TimeScheduleGeneratedComments"] as! NSDictionary
        let timeschedLines = TimeScheduleGeneratedComments["Lines"] as! [[String: Any]]
        var timeSchedComm = ""
        for line in timeschedLines {
            timeSchedComm = "\(timeSchedComm) \(line["Text"] as! String)"
        }
        //        print(secComm)
        //        print(timeSchedComm)
        let notes = "\(secComm) \(timeSchedComm)"
        let DaysOfWeek = meetingArr["DaysOfWeek"] as! [String: Any]
        let meetingDates = DaysOfWeek["Text"] as! String
        //        print(meetingDates)
        course.set(campus: nilFilter(json["CourseCampus"]!) as! String, courseTitle: nilFilter(json["CourseTitle"]!) as! String, courseTitleLong: nilFilter(json["CourseTitleLong"]!) as! String, courseDesc: nilFilter(json["CourseDescription"]!) as! String, currentEnrollment: nilFilter(json["CurrentEnrollment"]!) as! Int, building: building, roomNum: roomNum, startTime: start, endTime: end, minCredit: minCred, roomCapacity: cap, SLN: nilFilter(json["SLN"]!) as! String, notes: notes, meetingDates: meetingDates)
        mjr.addCourseIndex(nilFilter(json["SLN"]!) as! String, indexCourse)
        parsePrereq(json, course)
    }
}

extension URLSession {
    func synchronousDataTask(urlrequest: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}

// ADDED: Tab Bar Block
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

