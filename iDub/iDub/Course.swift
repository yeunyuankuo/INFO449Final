//
//  Course.swift
//  iDub
//
//  Created by Jessie Kuo on 03/12/2017.
//  Copyright © 2017 Kelley Lu Chen. All rights reserved.
//

import Foundation

public class Course {
    private let courseNumber: String
    private let courseTitle: String
    private let courseTitleLong: String
    private var courseAbbr: String
    private var campus = ""
    private var courseDesc = ""
    private var currentEnrollment = 0
    private var building = ""
    private var roomNum = 0
    private var startTime = ""
    private var endTime = ""
    private var minCredit = 0.0
    private var roomCapacity = 0
    private var SLN = 0
    private var notes = ""
    
    init(courseNumber: String, courseTitle: String, courseTitleLong: String, courseAbbr: String) {
        self.courseNumber = courseNumber
        self.courseTitle = courseTitle
        self.courseTitleLong = courseTitleLong
        self.courseAbbr = courseAbbr
    }
    
    public func set(campus: String, courseDesc: String, currentEnrollment: Int, building: String, roomNum: Int, startTime: String, endTime: String, minCredit: Double, roomCapacity: Int, SLN: Int, notes: String) {
        self.campus = campus
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
    }
    
}
