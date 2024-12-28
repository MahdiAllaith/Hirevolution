//
//  LabelItemView.swift
//  Hirevolution
//
//  Created by Yahya on 06/12/2024.
//


import UIKit

class LabelItemView: UIView {

    @IBOutlet weak var labelItemView: UILabel!

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
        let nib = UINib(nibName: "LabelItemView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    func updateLabel(withText text: String) {
        labelItemView.text = text
    }
}