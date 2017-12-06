//
//  CourseListViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kelley Lu Chen. All rights reserved.
//

import UIKit

class CourseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var courseTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let courses = ["HCDE", "CSE"]       // placeholder
    private var filteredData = [String]()       // placeholder (string type)
    private var isSearching = false
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "courseCell")
        
        if (isSearching) {
            cell.textLabel?.text = filteredData[indexPath.row]
        } else {
            cell.textLabel?.text = courses[indexPath.row]
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching) {
            return filteredData.count
        }
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FilterPageSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "FilterPageSegue") {
            let dest = segue.destination as! CourseFilterViewController
            
            dest.field = courses[sender as! Int]
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
            
            filteredData = courses.filter({$0.lowercased().contains(searchBar.text!.lowercased())})
            courseTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getCurr()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    // ************ Kelley *************
    
    
    
    
    var majors = [Major]()

    private let KiwonToken = "A78CBA6B-6964-42C2-B832-C54F32A58B1E"
    // Information about the course
    private let urlDefault = "https://ws.admin.washington.edu/student/v5/course/2017,autumn,HCDE,318.json"
    private let urlSection = "https://ws.admin.washington.edu/student/v5/course/2017,winter,cse,417/a.json"
    private let urlDegree = "https://ws.admin.washington.edu/student/v5/degree.json?major_abbr=a%20a&pathway=0"
    //private let urlMajor = "https://ws.admin.washington.edu/student/v5/degree /major_abbr=%22CSE%22&pathway=1&year=2017&quarter=winter.json"
    private let urlProgram = "https://ws.admin.washington.edu/student/v5/program.json?first_effective_year=2017&first_effective_quarter=autumn"
    private let urlCurr = "https://ws.admin.washington.edu/student/v5/curriculum.json?year=2017&quarter=autumn"
    
    
    // Fetch all curriculums
    private func getCurr() {
        // change this url to test different resources
        var request = URLRequest(url: URL(string: urlCurr)!)
        //print(request)
        request.httpMethod = "GET"
        
        let access_token = KiwonToken
        
        //You endpoint is setup as OAUTH 2.0 and we are sending Bearer token in Authorization header
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, err) in
            if let response = response {
                //NSLog("\(response)")
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    self.parseCurriculum(json)
                    //let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    
                }
                catch {
                    NSLog("\(error)")
                }
            }
            print("test1 \(self.majors.count)")
            }.resume()
        print("test2 \(self.majors.count)")
    }
    
    
    // Fetch all the courses within the given curriculum
    private func fetchCourses(_ classUrl: String, _ indx: Int) {
        // change this url to test different resources
        var request = URLRequest(url: URL(string: classUrl)!)
        //print(request)
        request.httpMethod = "GET"
        let access_token = KiwonToken
        
        //You endpoint is setup as OAUTH 2.0 and we are sending Bearer token in Authorization header
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, err) in
            if let response = response {
                //NSLog("\(response)")
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    self.parseClasses(json, indx)
                    //print(json)
                    //let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    
                }
                catch {
                    NSLog("\(error)")
                }
            }
            }.resume()
    }
    
    // Parse the curriculum and put information into majors object
    private func parseCurriculum(_ json: NSDictionary) {
        let fields = json["Curricula"] as! NSArray
        for each in fields {
            let abbr = each as! NSDictionary
            let mjr = Major(curriculumAbbr: abbr["CurriculumAbbreviation"] as! String,curriculumFullName: abbr["CurriculumFullName"] as! String, curriculumName: abbr["CurriculumName"] as! String)
            majors.append(mjr)
        }
        getClass()
        print("hi")
    }
    
    // Parse the returned list of classes and save it into class objects.
    private func getClass() {
        var index = 0
        for each in majors {
            var urlCourses = "https://ws.admin.washington.edu/student/v5/course.json?year=2017&quarter=autumn&curriculum_abbreviation="
            let maj = each
            let abbr = maj.getAbbr()
            let replaced = abbr.replacingOccurrences(of: " ", with: "")
            
            urlCourses = "\(urlCourses)\(replaced)"
            fetchCourses(urlCourses, index)
            index += 1
        }
    }
    
    private func parseClasses(_ json: NSDictionary, _ indx: Int) {
        let mjr = majors[indx]
        var mjrCourses = [Course]()
        let courseJson = json["Courses"] as? NSArray
        if (courseJson != nil) {
            for each in courseJson! {
                let cls = each as! NSDictionary
                //print(cls)
                let course = Course(courseNumber: cls["CourseNumber"] as! String, courseTitle: cls["CourseTitle"] as! String, courseTitleLong: cls["CourseTitleLong"] as! String, courseAbbr: cls["CurriculumAbbreviation"] as! String)
                mjrCourses.append(course)
            }
            mjr.setCourses(newCourses: mjrCourses)
        }
    }
    
}
