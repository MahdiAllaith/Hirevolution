//
//  CVItemView.swift
//  Hirevolution
//
//  Created by Yahya on 06/12/2024.
//


import UIKit

class CVItemView: UIView {

    @IBOutlet weak var cVItemView: UILabel!

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
        let nib = UINib(nibName: "CVItemView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    func configure(withCV cv: CVForm.CV) {
        cVItemView.text = cv.formattedCreationDate()
    }
}
