//
//  UpdatePasswordViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire

class UpdatePasswordViewController: UIViewController {
    
    var phone: String?
    
    lazy var passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Mật khẩu mới"
        tf.labelColor = .lightGray
        tf.dividerHeight = 0.5
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var confirmPasswordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Xác nhận mật khẩu"
        tf.labelColor = .lightGray
        tf.dividerHeight = 0.5
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var updatePasswordButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Đổi Mật Khẩu", for: .normal)
        b.backgroundColor = .red
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.addTarget(self, action: #selector(handleUpdatePassword), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        
        view.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32).isActive = true
        confirmPasswordTextField.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor).isActive = true
        confirmPasswordTextField.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(updatePasswordButton)
        updatePasswordButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 32).isActive = true
        updatePasswordButton.leftAnchor.constraint(equalTo: confirmPasswordTextField.leftAnchor).isActive = true
        updatePasswordButton.rightAnchor.constraint(equalTo: confirmPasswordTextField.rightAnchor).isActive = true
        updatePasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
        alertController.addAction(closeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showAlert2(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleUpdatePassword() {
        if passwordTextField.text!.isEmpty || confirmPasswordTextField.text!.isEmpty {
            self.showAlert(title: "Lỗi", message: "Vui lòng nhập mật khẩu")
        }
        else {
            if passwordTextField.text! != confirmPasswordTextField.text! {
                self.showAlert(title: "Lỗi", message: "Mật khẩu không trùng khớp. Vui lòng nhập lại")
            }
            else {
                self.updatePassword()
            }
        }
    }
    
    private func updatePassword() {
        guard let url = URL(string: UPDATE_PASSWORD_API_URL) else { return }
        let parameters: Parameters = ["phone": phone!, "new_password": passwordTextField.text!]
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            if let data = response.data {
                do {
                    if let value = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        let error = value["error"] as? Bool
                        if error != true {
                            self.showAlert2(title: "Thành Công", message: "Đổi mật khẩu thành công")
                        }
                    }
                } catch {
                    print(error)
                }
            } else if let error = response.error {
                print(error)
            }
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = "Cập Nhật Mật Khẩu"
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension UpdatePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textField = textField as? CustomTextField
        textField?.dividerColor = MAIN_COLOR
        textField?.labelColor = MAIN_COLOR
        textField?.dividerHeight = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textField = textField as? CustomTextField
        textField?.dividerColor = .lightGray
        textField?.labelColor = .lightGray
        textField?.dividerHeight = 0.5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textField = textField as? CustomTextField
        textField?.endEditing(true)
        textField?.dividerColor = .lightGray
        textField?.labelColor = .lightGray
        textField?.dividerHeight = 0.5
        return true
    }
    
}
