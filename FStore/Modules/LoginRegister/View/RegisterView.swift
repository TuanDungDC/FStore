//
//  RegisterView.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class RegisterView: UIView, UITextFieldDelegate {
    
    var loginRegisterViewController: LoginRegisterViewController?
    
    lazy var nameTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "HỌ TÊN"
        tf.placeholderString = "Nhập họ tên"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 15)
        tf.returnKeyType = UIReturnKeyType.next
        tf.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        if #available(iOS 12.0, *) {
            tf.textContentType = UITextContentType.oneTimeCode
        } else {
            // Fallback on earlier versions
            tf.textContentType = UITextContentType.init(rawValue: "")
        }
        return tf
    }()
    
    lazy var phoneTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "SỐ ĐIỆN THOẠI"
        tf.placeholderString = "Nhập số điện thoại"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 15)
        tf.keyboardType = UIKeyboardType.numberPad
        tf.addDoneButtonOnKeyboard()
        tf.addTarget(self, action: #selector(phoneTextFieldDidChange), for: .editingChanged)
        if #available(iOS 12.0, *) {
            tf.textContentType = UITextContentType.oneTimeCode
        } else {
            // Fallback on earlier versions
            tf.textContentType = UITextContentType.init(rawValue: "")
        }
        return tf
    }()
    
    lazy var passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "MẬT KHẨU"
        tf.placeholderString = "Nhập mật khẩu"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 15)
        tf.returnKeyType = UIReturnKeyType.go
        tf.autocorrectionType = .no
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        if #available(iOS 12.0, *) {
            tf.textContentType = UITextContentType.oneTimeCode
        } else {
            // Fallback on earlier versions
            tf.textContentType = UITextContentType.init(rawValue: "")
        }
        return tf
    }()
    
    lazy var registerButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .red
        b.setTitle("ĐĂNG KÝ", for: .normal)
        b.tintColor = .white
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkUserName() {
        if nameTextField.text!.isEmpty {
            nameTextField.dividerColor = .red
            nameTextField.errorLabelString = "Vui lòng nhập họ tên"
        }
    }
    
    private func checkPhoneNumber() {
        if phoneTextField.text!.isEmpty {
            phoneTextField.dividerColor = .red
            phoneTextField.errorLabelString = "Vui lòng nhập số điện thoại"
        }
        else if !phoneTextField.text!.isValidPhone() {
            phoneTextField.dividerColor = .red
            phoneTextField.errorLabelString = "Số điện thoại không đúng"
        }
    }
    
    private func checkPassword() {
        if passwordTextField.text!.isEmpty {
            passwordTextField.dividerColor = .red
            passwordTextField.errorLabelString = "Vui lòng nhập mật khẩu"
        }
        else if passwordTextField.text!.count < 8 {
            passwordTextField.dividerColor = .red
            passwordTextField.errorLabelString = "Mật khẩu ít nhất phải 8 ký tự"
        }
    }
    
    @objc private func handleRegister() {
        checkUserName()
        checkPhoneNumber()
        checkPassword()
        
        if !nameTextField.text!.isEmpty && nameTextField.errorLabelString == nil && !phoneTextField.text!.isEmpty && phoneTextField.errorLabelString == nil && !passwordTextField.text!.isEmpty && passwordTextField.errorLabelString == nil {
            register()
        }
    }
    
    private func register() {
        guard let url = URL(string: USER_PHONE_CHECK_API_URL),
              let phoneText = phoneTextField.text else { return }
        
        let parameters: Parameters = ["phone": phoneText]
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Sử dụng responseDecodable để tự động phân tích dữ liệu JSON thành kiểu mong muốn
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [String: Bool].self) { [unowned self] response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let result):
                if let isExists = result["isExists"], isExists {
                    self.loginRegisterViewController?.showAlert(title: "Lỗi đăng ký", message: "Số điện này đã được sử dụng")
                } else {
                    self.loginRegisterViewController?.showVerificationAlert(title: "Xác Minh Số Điện Thoại", message: "Chúng tôi sẽ gửi mã xác thực đến số điện thoại \(phoneText). Vui lòng xác thực để đảm bảo số điện thoại này là đúng!", name: self.nameTextField.text!, password: self.passwordTextField.text!, phone: phoneText, accountType: 0)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func nameTextFieldDidChange() {
        nameTextField.dividerColor = MAIN_COLOR
        nameTextField.errorLabelString = nil
    }
    
    @objc private func phoneTextFieldDidChange() {
        phoneTextField.dividerColor = MAIN_COLOR
        phoneTextField.errorLabelString = nil
    }
    
    @objc private func passwordTextFieldDidChange() {
        passwordTextField.dividerColor = MAIN_COLOR
        passwordTextField.errorLabelString = nil
    }
    
    private func setupViews() {
        addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(phoneTextField)
        phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 44).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 44).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(registerButton)
        registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32).isActive = true
        registerButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        registerButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            if nameTextField.dividerColor != .red {
                nameTextField.dividerColor = MAIN_COLOR
            }
            nameTextField.dividerHeight = 2
        }
        if textField == passwordTextField {
            if passwordTextField.dividerColor != .red {
                passwordTextField.dividerColor = MAIN_COLOR
            }
            passwordTextField.dividerHeight = 2
        }
        if textField == phoneTextField {
            if phoneTextField.dividerColor != .red {
                phoneTextField.dividerColor = MAIN_COLOR
            }
            phoneTextField.dividerHeight = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            if nameTextField.errorLabelString == nil {
                nameTextField.dividerColor = .lightGray
            }
            nameTextField.dividerHeight = 1
        }
        if textField == passwordTextField {
            if passwordTextField.errorLabelString == nil {
                passwordTextField.dividerColor = .lightGray
            }
            passwordTextField.dividerHeight = 1
        }
        if textField == phoneTextField {
            if phoneTextField.errorLabelString == nil {
                phoneTextField.dividerColor = .lightGray
            }
            phoneTextField.dividerHeight = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.endEditing(true)
            handleRegister()
        }
        return true
    }
    
    
    
}
