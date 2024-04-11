//
//  ProfileTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import MBRadioCheckboxButton

class ProfileTableViewCell: UITableViewCell, RadioButtonDelegate {
    
    var profileTableViewController: ProfileTableViewController?
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = MAIN_COLOR
        return l
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    let maleButton: RadioButton = {
        let b = RadioButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.radioCircle = RadioButtonCircleStyle.init(outerCircle: 16, innerCircle: 10, outerCircleBorder: 1, contentPadding: 8)
        b.setTitle("Nam", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.setTitleColor(.black, for: .normal)
        b.radioButtonColor = RadioButtonColor.init(active: MAIN_COLOR, inactive: .lightGray)
        b.tag = 0
        return b
    }()
    
    let femaleButton: RadioButton = {
        let b = RadioButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.radioCircle = RadioButtonCircleStyle.init(outerCircle: 16, innerCircle: 10, outerCircleBorder: 1, contentPadding: 8)
        b.setTitle("Nữ", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.setTitleColor(.black, for: .normal)
        b.radioButtonColor = RadioButtonColor.init(active: MAIN_COLOR, inactive: .lightGray)
        b.tag = 1
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField(isHidden: Bool) {
        if isHidden == false {
            contentView.addSubview(textField)
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
            textField.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        }
    }
    
    func setupRadioButton(isHidden: Bool) {
        let width: CGFloat = 60
        let height: CGFloat = 18
        if isHidden == false {
            contentView.addSubview(maleButton)
            maleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
            maleButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
            maleButton.widthAnchor.constraint(equalToConstant: width).isActive = true
            maleButton.heightAnchor.constraint(equalToConstant: height).isActive = true
            maleButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            contentView.addSubview(femaleButton)
            femaleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
            femaleButton.leftAnchor.constraint(equalTo: maleButton.rightAnchor, constant: 16).isActive = true
            femaleButton.widthAnchor.constraint(equalToConstant: width - 10).isActive = true
            femaleButton.heightAnchor.constraint(equalToConstant: height).isActive = true
            femaleButton.frame = CGRect(x: 0, y: 0, width: width - 10, height: height)
            
            let radioButtonContainer = RadioButtonContainer()
            radioButtonContainer.delegate = self
            radioButtonContainer.addButtons([maleButton, femaleButton])
        }
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        
        setupTextField(isHidden: true)
        setupRadioButton(isHidden: true)
        
    }
    
    func radioButtonDidSelect(_ button: RadioButton) {
        profileTableViewController?.gender = String(button.tag)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
    
}
