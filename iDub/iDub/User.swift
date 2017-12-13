//
//  User.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 9..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import Foundation

public class User {
    private var userName : String
    private var major = ""
    private var year = ""
    private var plannedCourses: [Course] = []
    private var completedCourses: [Course] = []
    var addDuplicate: Set = [""]
    var planDuplicate: Set = [""]
    
    init(userName: String) {
        self.userName = userName
    }
    
    init(userName: String, major: String, year: String, plannedCourses: [Course], completedCourses: [Course]) {
        self.userName = userName
        self.major = major
        self.year = year
        self.plannedCourses = plannedCourses
        self.completedCourses = completedCourses
    }
    
    public func getUsername() -> String {
        return self.userName
    }
    
    public func getMajor() -> String {
        return self.major
    }
    
    public func getYear() -> String {
        return self.year
    }
    
    public func getClassTaken() -> [Course]{
        return completedCourses
    }
    
    public func getClassPlanned() -> [Course]{
        return plannedCourses
    }
    
    public func addCourseTaken(_ course: Course) {
        if (!self.addDuplicate.contains(course.getSLN())) {
            self.addDuplicate.insert(course.getSLN())
            self.completedCourses.append(course)
        }
    }
    
    public func setCourseTaken(_ courses: [Course]) {
        self.completedCourses = courses
    }
    
    public func addCoursePlanned(_ course: Course) {
        if (!self.planDuplicate.contains(course.getSLN())) {
            self.planDuplicate.insert(course.getSLN())
            self.plannedCourses.append(course)
        }
    }

    public func removeCourseTaken(_ course: Course) {
        var index = -1
        for completedCourse in completedCourses {
            index += 1;
            if (completedCourse.getSLN() == course.getSLN()) {
                completedCourses.remove(at: index)
                addDuplicate.remove(completedCourse.getSLN())
            }
        }
    }
    
    public func removeCoursePlanned(_ course: Course) {
        var index = -1
        for plannedCourse in plannedCourses {
            index += 1;
            if (plannedCourse.getSLN() == course.getSLN()) {
                plannedCourses.remove(at: index)
                planDuplicate.remove(plannedCourse.getSLN())
            }
        }
    }
    
    public func setUsername(username: String) {
        self.userName = username
    }
    
    public func setMajor(major: String) {
        self.major = major
    }
    
    public func setYear(year: String) {
        self.year = year
    }
    
    public func toJSON() -> NSDictionary {
        var planDics = [NSDictionary]()
        var compDics = [NSDictionary]()
        for course in plannedCourses {
            planDics.append(course.toJSON())
        }
        
        for course in completedCourses {
            compDics.append(course.toJSON())
        }
        
        return [
            "userName": userName,
            "major": major,
            "year": year,
            "plannedCourses": planDics,
            "completedCourses": compDics
        ]
    }
}

