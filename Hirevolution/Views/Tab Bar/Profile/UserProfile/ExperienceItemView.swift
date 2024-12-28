//
//  ExperienceItemView.swift
//  Hirevolution
//
//  Created by Yahya on 06/12/2024.
//


import UIKit

class ExperienceItemView: UIView {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet var companyImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // Load the XIB file
        let nib = UINib(nibName: "ExperienceItemView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    func configure(experience: Experience) {
        jobTitleLabel.text = experience.jobTitle
        companyNameLabel.text = experience.companyName
        
        let endDateStr = experience.isStillWorkingHere ? "Present" : experience.endDate ?? "Present"
        
        durationLabel.text = "\(experience.startDate) - \(endDateStr)"
    }
}
