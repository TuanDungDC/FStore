//
//  ForgotPasswordViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {
    
    lazy var phoneTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Số điện thoại"
        tf.labelColor = .lightGray
        tf.dividerHeight = 0.5
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    
    lazy var getPasswordButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Lấy Lại Mật Khẩu", for: .normal)
        b.backgroundColor = .red
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        
        view.addSubview(phoneTextField)
        phoneTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(getPasswordButton)
        getPasswordButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 32).isActive = true
        getPasswordButton.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor).isActive = true
        getPasswordButton.rightAnchor.constraint(equalTo: phoneTextField.rightAnchor).isActive = true
        getPasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    private func setupNavBar() {
        navigationItem.title = "Quên Mật Khẩu"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleForgotPassword() {
        if let phoneText = phoneTextField.text, phoneText.isValidPhone() {
            guard let url = URL(string: USER_PHONE_CHECK_API_URL) else { return }
            let parameters: Parameters = ["phone": phoneText]
            
            // Sử dụng AF thay vì Alamofire và response thay cho responseJSON
            AF.request(url, method: .post, parameters: parameters).response { [weak self] response in
                switch response.result {
                case .success(let data):
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let isExists = json["isExists"] as? Bool {
                        if !isExists {
                            self?.showAlert(title: "Có lỗi xảy ra", message: "Số điện thoại không tồn tại. Vui lòng nhập lại")
                        } else {
                            // Tiếp tục với việc xác minh số điện thoại
                            guard let verifyUrl = URL(string: VERIFY_API_URL) else { return }
                            let verifyParameters: Parameters = ["phone": phoneText]
                            
                            AF.request(verifyUrl, method: .post, parameters: verifyParameters).response { verifyResponse in
                                switch verifyResponse.result {
                                case .success(let verifyData):
                                    if let verifyData = verifyData, let verifyJson = try? JSONSerialization.jsonObject(with: verifyData, options: []) as? [String: Any], let error = verifyJson[Keys.error] as? Bool {
                                        if error {
                                            let message = verifyJson[Keys.message] as? String ?? "Đã xảy ra lỗi."
                                            self?.showAlert(title: "Có lỗi xảy ra", message: message)
                                        } else {
                                            // Chuyển đến màn hình xác minh
                                            let verification = VerificationViewController()
                                            verification.phone = phoneText
                                            verification.type = 1
                                            self?.navigationController?.pushViewController(verification, animated: true)
                                        }
                                    }
                                case .failure(let verifyError):
                                    print(verifyError)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            showAlert(title: "Sai thông tin", message: "Vui lòng kiểm tra lại số điện thoại.")
        }
    }
    
}


extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textField = textField as? CustomTextField
        textField?.dividerColor = MAIN_COLOR
        textField?.labelColor = MAIN_COLOR
        textField?.dividerHeight = 1
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
