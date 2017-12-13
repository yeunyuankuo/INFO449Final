//
//  Major.swift
//  iDub
//
//  Created by Jessie Kuo on 03/12/2017.
//  Copyright © 2017 Kiwon Jeong. All rights reserved.
//

import Foundation

public class Major {
    private let curriculumAbbr: String
    private let curriculumFullName: String
    private let curriculumName: String
    private var courses: [Course] = []
    private var courseIndex = [String: Int]()
    
    init(curriculumAbbr: String, curriculumFullName: String, curriculumName: String) {
        self.curriculumAbbr = curriculumAbbr
        self.curriculumFullName = curriculumFullName
        self.curriculumName = curriculumName
    }
    
    public func addCourseIndex(_ inputSLN: String, _ index: Int) {
        self.courseIndex[inputSLN] = index
    }
    
    public func setCourseIndex(_ inputDic: [String: Int]) {
        self.courseIndex = inputDic
    }
    
    public func getAbbr() -> String {
        return curriculumAbbr
    }
    
    public func getCourseIndex(_ inputCourse: Course) -> Int {
        if (courseIndex[inputCourse.getSLN()] != nil) {
            let result = courseIndex[inputCourse.getSLN()]
            return result!
        } else {
            return -1
        }
    }
    
    public func getCurrFullName() -> String {
        return curriculumFullName
    }
    
    public func getCurrName() -> String {
        return curriculumName
    }
    
    public func addCourse(newCourse: Course) {
        courses.append(newCourse)
    }
    
    public func replaceCourses(newCourses: [Course]) {
        self.courses = newCourses
    }
    
    public func getCourses() -> [Course] {
        return courses
    }
    
    public func setCourses(newCourses: [Course]) {
        courses = newCourses
    }
    
    public func toJSON() -> NSDictionary {
        var courseDics = [NSDictionary]()
        for course in courses {
            courseDics.append(course.toJSON())
        }

        return [
            "curriculumAbbr" : curriculumAbbr,
            "curriculumFullName" : curriculumFullName,
            "curriculumName" : curriculumName,
            "courses" : courseDics
        ]
    }
}
