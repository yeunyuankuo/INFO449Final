//
//  CourseDetailViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
    // added next 4 lines.
    var course: Course = Course(courseNumber: "String", courseAbbr: "String")
    private var isFromFilter: Bool!
    private var colorToBeUsed: UIColor!
    public func setCourse(_ sender: Any, _ from: Bool, _ color: UIColor) {
        self.course = sender as! Course
        self.isFromFilter = from
        self.colorToBeUsed = color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDesc() // added
        self.navigationItem.title = "iDub"
        colorBlockDesc.backgroundColor = colorToBeUsed
        // Do any additional setup after loading the view.
        descriptionScrollView.contentSize = UIScreen.main.bounds.size
        //        descriptionScrollView.addSubview(scrollingView)
        descriptionScrollView.showsVerticalScrollIndicator = true
        descriptionScrollView.delegate = self
        descriptionScrollView.isPagingEnabled = true
        descriptionScrollView.indicatorStyle = .default
        descriptionScrollView.canCancelContentTouches = true
        descriptionScrollView.delaysContentTouches = true
        descriptionScrollView.isExclusiveTouch = true
        self.hideKeyboardWhenTappedAround()

    }
    
    // added
    @IBOutlet weak var detailSection: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseLongName: UILabel!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    @IBOutlet weak var colorBlockDesc: UIView!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var sln: UILabel!
    @IBOutlet weak var campus: UILabel!
    @IBOutlet weak var building: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var registered: UILabel!
    @IBOutlet weak var numSeats: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var prereq: UILabel!
    public func populateDesc() {
        courseName.text = "\(course.getCourseAbbr()) \(course.getCourseNumber())"
        courseLongName.text = "\(course.getCourseTitleLong())"
        let creditsText = credits.text as! String
        credits.text = "\(creditsText) \(course.getCredits())"
        let slnText = sln.text as! String
        sln.text = "\(slnText) \(course.getSLN())"
        let campusText = campus.text as! String
        campus.text = "\(campusText) \(course.getCampus())"
        let buildingText = building.text as! String
        building.text = "\(buildingText) \(course.getBuilding())\(course.getRoom())"
        let timeText = time.text as! String
        time.text = "\(timeText) \(course.getStartTime())"
        desc.text = "\(course.getDesc())"
        let endText = endTime.text as! String
        endTime.text = "\(endText) \(course.getEndTime())"
        let prq = course.getPrereq() as! [Course]
        var prqString = ""
        for cls in prq {
            prqString = "\(prqString) \(cls.getCourseAbbr()) \(cls.getCourseNumber())"
        }
        registered.text = "\(course.getCurrentEnrollment() as! Int)"
        numSeats.text = "/\(course.getRoomCapacity())"
        
        notes.text = "\(course.getNotes())"
        prereq.text = prqString
        [courseLongName .sizeToFit()]
        [credits .sizeToFit()]
        [sln .sizeToFit()]
        [campus .sizeToFit()]
        [building .sizeToFit()]
        [time .sizeToFit()]
        [desc .sizeToFit()]
        [endTime .sizeToFit()]
        [prereq .sizeToFit()]
        [notes .sizeToFit()]
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

extension CourseDetailViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = round(descriptionScrollView.contentOffset.x / descriptionScrollView.frame.size.width)
        print(index)
    }
}

