//
//  Major.swift
//  iDub
//
//  Created by Jessie Kuo on 03/12/2017.
//  Copyright © 2017 Kelley Lu Chen. All rights reserved.
//

import Foundation

public class Major {
    private let curriculumAbbr: String
    private let curriculumFullName: String
    private let curriculumName: String
    private var courses: [Course] = []
    
    init(curriculumAbbr: String, curriculumFullName: String, curriculumName: String) {
        self.curriculumAbbr = curriculumAbbr
        self.curriculumFullName = curriculumFullName
        self.curriculumName = curriculumName
    }
    
    public func getAbbr() -> String {
        return curriculumAbbr
    }
    public func addCourse(newCourse: Course) {
        courses.append(newCourse)
    }
    
    public func getCourses() -> [Course] {
        return courses
    }
    
    public func setCourses(newCourses: [Course]) {
        courses = newCourses
    }
}
