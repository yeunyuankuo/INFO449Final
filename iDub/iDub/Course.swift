//
//  Course.swift
//  iDub
//
//  Created by Jessie Kuo on 03/12/2017.
//  Copyright © 2017 Kiwon Jeong. All rights reserved.
//

import Foundation

public class Course {
    private let courseNumber: String
    private var courseTitle = ""
    private var courseTitleLong = ""
    private var courseAbbr: String
    private var preReq = [Course]() // added
    private var campus = ""
    private var courseDesc = ""
    private var currentEnrollment = 0
    private var building = ""
    private var roomNum = ""
    private var startTime = ""
    private var endTime = ""
    private var minCredit = ""
    private var roomCapacity = 0
    private var SLN = ""
    private var notes = ""
    private let sectionID: String
    private let sectionHref: String
    private var majorOnly = false
    private var meetingDates = "" // added
    
    init(courseNumber: String, courseAbbr: String, secID: String, secHref: String) {
        self.courseNumber = courseNumber
        self.courseAbbr = courseAbbr
        self.sectionID = secID
        self.sectionHref = secHref
    }
    
    init(courseNumber: String, courseAbbr: String) {
        self.courseNumber = courseNumber
        self.courseAbbr = courseAbbr
        self.sectionID = ""
        self.sectionHref = ""
    }
    
    public func set(campus: String, courseTitle: String, courseTitleLong: String, courseDesc: String, currentEnrollment: Int, building: String, roomNum: String, startTime: String, endTime: String, minCredit: String, roomCapacity: Int, SLN: String, notes: String, meetingDates: String) {
        self.campus = campus
        self.courseTitle = courseTitle
        self.courseTitleLong = courseTitleLong
        self.courseDesc = courseDesc
        self.currentEnrollment = currentEnrollment
        self.building = building
        self.roomNum = roomNum
        self.startTime = startTime
        self.endTime = endTime
        self.minCredit = minCredit
        self.roomCapacity = roomCapacity
        self.SLN = SLN
        self.notes = notes
        self.meetingDates = meetingDates
    }
    
    // added
    public func getCourseNumber() -> String {
        return self.courseNumber;
    }
    
    // added
    public func setPrereqCourses(_ preReq:[Course]) {
        self.preReq = preReq
    }
    
    // added this but not sure if its necessary
    public func setMajorOnly() {
        self.majorOnly = true
    }
    
    // added
    public func getAbbr() -> String {
        return self.courseAbbr
    }
    
    public func getCourseTitleLong() -> String {
        return courseTitleLong
    }
    
    public func getSectionID() -> String {
        return sectionID
    }
    
    public func getSLN() -> String {
        return SLN
    }
    
    public func getSectionHref() -> String {
        return sectionHref
    }
    
    public func getCurrentEnrollment() -> Int {
        return currentEnrollment
    }
    
    public func getRoomCapacity() -> Int {
        return roomCapacity
    }
    
    public func getStartTime() -> String { // added
        return startTime
    }
    
    public func getEndTime() -> String { // added
        return endTime
    }
    
    public func getNotes() -> String { // added
        return notes
    }
    
    public func getPrereq() -> [Course] { // added
        return preReq
    }
    
    public func getMeetingDate() -> String { // added
        return meetingDates
    }
    
    
    public func getCourseAbbr() -> String { // added 2
        return courseAbbr
    }
    
    public func getCredits() -> String { //added 2
        return minCredit
    }
    
    public func getCampus() -> String { // added 2
        return campus
    }
    
    public func getBuilding() -> String { // added 2
        return building
    }
    
    public func getRoom() -> String { // added 2
        return roomNum
    }
    
    public func getDesc() -> String {
        return courseDesc
    }
    
    public func toJSON() -> NSDictionary {
        var preReqDics = [NSDictionary]()
        for course in preReq {
            preReqDics.append(course.toJSON())
        }
        
        
        return [
            "courseNumber" : courseNumber,
            "courseTitle" : courseTitle,
            "courseTitleLong" : courseTitleLong,
            "courseAbbr" : courseAbbr,
            "preReq" : preReqDics,
            "campus" : campus,
            "courseDesc" : courseDesc,
            "currentEnrollment" : currentEnrollment,
            "building" : building,
            "roomNum" : roomNum,
            "startTime" : startTime,
            "endTime" : endTime,
            "minCredit" : minCredit,
            "roomCapacity" : roomCapacity,
            "SLN" : SLN,
            "notes" : notes,
            "sectionID" : sectionID,
            "sectionHref" : sectionHref,
            "majorOnly" : majorOnly,
            "meetingDates" : meetingDates
        ]
    }
    
}
