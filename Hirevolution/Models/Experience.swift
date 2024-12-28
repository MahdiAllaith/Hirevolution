//
//  Experience.swift
//  Hirevolution
//
//  Created by Yahya on 06/12/2024.
//


import Foundation

struct Experience {
    let jobTitle: String
    let companyName: String
    let startDate: String
    let endDate: String?
    let isStillWorkingHere: Bool
    let aboutTheWork: String

    // Initializer for Experience
    init(jobTitle: String, companyName: String, startDate: String, endDate: String?, isStillWorkingHere: Bool, aboutTheWork: String) {
        self.jobTitle = jobTitle
        self.companyName = companyName
        self.startDate = startDate
        self.endDate = endDate
        self.isStillWorkingHere = isStillWorkingHere
        self.aboutTheWork = aboutTheWork
    }
    
    init(workExperience: WorkExperience) {
        jobTitle = workExperience.jobTitle
        companyName = workExperience.companyName
        startDate = workExperience.startDate
        endDate = workExperience.endDate
        isStillWorkingHere = workExperience.endDate == nil ? true : false
        aboutTheWork = workExperience.jobTitle
    }
}
