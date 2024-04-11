//
//  CustomStepper.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

protocol CustomStepperDelegate {
    func didSub(_: CustomStepper)
    func didAdd(_: CustomStepper)
}

class CustomStepper: UIView {
    
    var delegate: CustomStepperDelegate?
    
    var stepperValue: Int = 1 {
        didSet {
            self.valueLabel.text = "\(stepperValue)"
        }
    }
    
    private lazy var leftButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("–", for: .normal)
        b.setTitleColor(UIColor.darkGray, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = UIColor(white: 0.85, alpha: 1)
        b.addTarget(self, action: #selector(handleSub), for: .touchUpInside)
        return b
    }()
    
    private let valueLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.text = "1"
        l.font = UIFont.systemFont(ofSize: 16)
        l.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return l
    }()
    
    private lazy var rightButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("+", for: .normal)
        b.setTitleColor(UIColor.darkGray, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = UIColor(white: 0.85, alpha: 1)
        b.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return b
    }()
    
    let notificationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = .black
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .center
        l.layer.cornerRadius = 8
        l.clipsToBounds = true
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(leftButton)
        leftButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        leftButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 3).isActive = true
        
        addSubview(valueLabel)
        valueLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: leftButton.rightAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        valueLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 3).isActive = true
        
        addSubview(rightButton)
        rightButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rightButton.leftAnchor.constraint(equalTo: valueLabel.rightAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        addSubview(notificationLabel)
        notificationLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor).isActive = true
        notificationLabel.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        notificationLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        notificationLabel.isHidden = true
    }
    
    @objc private func handleSub() {
        if stepperValue == 1 {
            notificationLabel.isHidden = false
            notificationLabel.text = "Số lượng tối thiểu là 1"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.notificationLabel.isHidden = true
            }
        }
        else {
            stepperValue -= 1
            self.delegate?.didSub(self)
        }
    }
    
    @objc private func handleAdd() {
        if stepperValue == 20 {
            notificationLabel.isHidden = false
            notificationLabel.text = "Số lượng tối đa là 20"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.notificationLabel.isHidden = true
            }
        }
        else {
            stepperValue += 1
            self.delegate?.didAdd(self)
        }
    }
}
