//
//  CustomTextField.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class CustomTextField: UITextField {
    
    private let label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private let dividerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        return v
    }()
    
    private let errorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .red
        return l
    }()
    
    var errorLabelString: String? {
        didSet {
            self.errorLabel.text = errorLabelString
        }
    }
    
    var placeholderString: String? {
        didSet {
            self.placeholder = placeholderString
        }
    }
    
    var labelString: String? {
        didSet {
            self.label.text = labelString
        }
    }
    
    var dividerHeight: CGFloat = 1 {
        didSet {
            self.dividerViewHeightContraint?.constant = dividerHeight
        }
    }
    
    var dividerColor: UIColor? {
        didSet {
            self.dividerView.backgroundColor = dividerColor
        }
    }
    
    var labelColor: UIColor = .black {
        didSet {
            self.label.textColor = labelColor
        }
    }
    
    var textfieldFontSize: UIFont = .systemFont(ofSize: 14) {
        didSet {
            self.font = textfieldFontSize
        }
    }
    
    var labelFontSize: UIFont = .systemFont(ofSize: 12) {
        didSet {
            self.label.font = labelFontSize
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dividerViewHeightContraint: NSLayoutConstraint?
    
    private func setupViews() {
        self.addSubview(label)
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.addSubview(dividerView)
        dividerView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dividerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerViewHeightContraint = NSLayoutConstraint(item: dividerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 1)
        self.addConstraint(dividerViewHeightContraint!)
        
        self.addSubview(errorLabel)
        errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor).isActive = true
    }
}
