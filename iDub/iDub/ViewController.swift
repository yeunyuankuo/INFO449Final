//
//  ViewController.swift
//  iDub
//
//  Created by Kelley Lu Chen on 12/3/17.
//  Copyright © 2017 Kelley Lu Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var majors = [Major]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurr()
        getClass()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private let KiwonToken = "A78CBA6B-6964-42C2-B832-C54F32A58B1E"
    // Information about the course
    private let urlDefault = "https://ws.admin.washington.edu/student/v5/course/2017,autumn,HCDE,318.json"
    private let urlSection = "https://ws.admin.washington.edu/student/v5/course/2017,winter,cse,417/a.json"
    private let urlDegree = "https://ws.admin.washington.edu/student/v5/degree.json?major_abbr=a%20a&pathway=0"
    //private let urlMajor = "https://ws.admin.washington.edu/student/v5/degree /major_abbr=%22CSE%22&pathway=1&year=2017&quarter=winter.json"
    private let urlProgram = "https://ws.admin.washington.edu/student/v5/program.json?first_effective_year=2017&first_effective_quarter=autumn"
    private let urlCurr = "https://ws.admin.washington.edu/student/v5/curriculum.json?year=2017&quarter=autumn"

    
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
                    //print(json)
                    //let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    
                }
                catch {
                    NSLog("\(error)")
                }
            }
            }.resume()
    }
    
    private func getClass() {
        var urlCourses = "https://ws.admin.washington.edu/student/v5/course.json?year=2017&quarter=autumn&curriculum_abbreviation="
        for each in majors {
            let maj = each
            let abbr = maj.getAbbr()
            urlCourses = "\(urlCourses) + \(abbr)"
            fetchCourses(urlCourses)
            
        }
    }
    private func fetchCourses(_ url: String, _ indx: Int) {
        // change this url to test different resources
        var request = URLRequest(url: URL(string: url)!)
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
    private func parseCurriculum(_ json: NSDictionary) {
        let fields = json["Curricula"] as! NSArray
        for each in fields {
            let abbr = each as! NSDictionary
            let mjr = Major(curriculumAbbr: abbr["CurriculumAbbreviation"] as! String,curriculumFullName: abbr["CurriculumFullName"] as! String, curriculumName: abbr["CurriculumName"] as! String)
            majors.append(mjr)
            print(mjr)
        }
    }
    
    private func parseClasses(_ json: NSDictionary, _ indx: Int) {
        let mjr = majors[indx]
        let courses = [Course]()
        for cls in 
        mjr.setCourses(newCourses: <#T##[Course]#>)
    }

}

