//
//  CVDetails.swift
//  Hirevolution
//
//  Created by Yahya on 07/12/2024.
//


import Foundation

/// A model representing details of a CV (Curriculum Vitae) file.
struct CVDetails {
    /// The local or remote file path (URL string) of the CV.
    let filePath: String
    
    /// A readable title or name for the CV.
    let title: String
    
    init(filePath: String, title: String) {
        self.filePath = filePath
        self.title = title
    }
}
