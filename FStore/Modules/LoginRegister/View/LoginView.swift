//
//  LoginView.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//


import UIKit
import Alamofire
import SVProgressHUD

class LoginView: UIView, UITextFieldDelegate {
    
    private let defaults = UserDefaults.standard
    var loginRegisterViewController: LoginRegisterViewController?
    
    lazy var phoneTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "SỐ ĐIỆN THOẠI"
        tf.placeholderString = "Nhập số điện thoại"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 15)
        tf.addDoneButtonOnKeyboard()
        tf.keyboardType = UIKeyboardType.numberPad
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
    
    lazy var forgotPasswordButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Quên mật khẩu?", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        b.sizeToFit()
        b.tintColor = MAIN_COLOR
        b.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return b
    }()
    
    lazy var loginButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("ĐĂNG NHẬP", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.backgroundColor = .red
        b.tintColor = .white
        b.layer.cornerRadius = 4
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
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
    
    @objc private func handleForgotPassword() {
        loginRegisterViewController?.showForgotPassword()
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
    }
    
    @objc private func handleLogin() {
        checkPhoneNumber()
        checkPassword()
        
        if !phoneTextField.text!.isEmpty && phoneTextField.errorLabelString == nil && !passwordTextField.text!.isEmpty && passwordTextField.errorLabelString == nil {
            login()
        }
        
    }

    @objc private func phoneTextFieldDidChange() {
        phoneTextField.dividerColor = MAIN_COLOR
        phoneTextField.errorLabelString = nil
    }
    
    @objc private func passwordTextFieldDidChange() {
        passwordTextField.dividerColor = MAIN_COLOR
        passwordTextField.errorLabelString = nil
    }
        
    private func login() {
        guard let url = URL(string: LOGIN_API_URL) else { return }
        let parameters: Parameters = ["phone": phoneTextField.text!, "password": passwordTextField.text!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Kiểm tra lỗi từ phản hồi JSON
                        if let error = json["error"] as? Bool, !error {
                            // Lưu trữ thông tin người dùng vào UserDefaults
                            self.defaults.set(json["id"] as? String, forKey: "id")
                            self.defaults.set(json["name"] as? String, forKey: "name")
                            self.defaults.set(json["phone"] as? String, forKey: "phone")
                            self.defaults.set(json["email"] as? String, forKey: "email")
                            self.defaults.set(json["gender"] as? String, forKey: "gender")
                            self.defaults.set(json["accountType"] as? String, forKey: "accountType")
                            self.defaults.set(json["avatarUrl"] as? String, forKey: "avatarUrl")
                            self.defaults.set(json["createAt"] as? String, forKey: "createAt")
                            self.defaults.set(json["birthday"] as? String, forKey: "birthday")
                            self.defaults.set(json["cartCount"] as? Int, forKey: "cartCount")
                            self.defaults.set(json["addressId"] as? String, forKey: "addressId")
                            self.defaults.set(true, forKey: "logged")
                            // Quay lại màn hình trước sau khi đăng nhập thành công
                            self.loginRegisterViewController?.handleBack()
                        } else {
                            // Hiển thị thông báo lỗi nếu có
                            let message = json["message"] as? String ?? "Thông tin đăng nhập không chính xác."
                            self.loginRegisterViewController?.showAlert(title: "Lỗi đăng nhập", message: message)
                        }
                    }
                } catch {
                    print("Lỗi khi phân tích cú pháp JSON: \(error)")
                }
            case .failure(let error):
                print("Lỗi mạng: \(error)")
                // Có thể hiển thị thông báo lỗi hoặc xử lý lỗi ở đây
            }
        }
    }

    
    func setupViews() {
        addSubview(phoneTextField)
        phoneTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 44).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: phoneTextField.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(forgotPasswordButton)
        forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24).isActive = true
        loginButton.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor).isActive = true
        loginButton.rightAnchor.constraint(equalTo: phoneTextField.rightAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            if phoneTextField.dividerColor != .red {
                phoneTextField.dividerColor = MAIN_COLOR
            }
            phoneTextField.dividerHeight = 2
        }
        if textField == passwordTextField {
            if passwordTextField.dividerColor != .red {
                passwordTextField.dividerColor = MAIN_COLOR
            }
            passwordTextField.dividerHeight = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            if phoneTextField.errorLabelString == nil {
                phoneTextField.dividerColor = .lightGray
            }
            phoneTextField.dividerHeight = 1
        }
        if textField == passwordTextField {
            if passwordTextField.errorLabelString == nil {
                passwordTextField.dividerColor = .lightGray
            }
            passwordTextField.dividerHeight = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .go {
            textField.endEditing(true)
            handleLogin()
        }
        return true
    }
    
}
