//
//  ConfirmationPasswordViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire

class PasswordConfirmationViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    lazy var passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Mật khẩu cũ"
        tf.labelColor = .lightGray
        tf.dividerHeight = 0.5
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var continutePasswordButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Tiếp Tục", for: .normal)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.addTarget(self, action: #selector(handleContinute), for: .touchUpInside)
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
        
        view.addSubview(continutePasswordButton)
        continutePasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32).isActive = true
        continutePasswordButton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor).isActive = true
        continutePasswordButton.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor).isActive = true
        continutePasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleContinute() {
        let phone = defaults.value(forKey: Keys.phone)!
        guard let url = URL(string: CONFIRM_OLD_PASSWORD_API_URL) else { return }
        let parameters: Parameters = ["phone": "0\(phone)", "old_password": passwordTextField.text!]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                           let error = json["error"] as? Bool, error == true {
                            self.showAlert(title: "Lỗi", message: "Mật khẩu không chính xác. Vui lòng nhập lại")
                        } else {
                            let updatePasswordViewController = UpdatePasswordViewController()
                            updatePasswordViewController.phone = "0\(phone)"
                            self.navigationController?.pushViewController(updatePasswordViewController, animated: true)
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    print("No data received from the server.")
                }
            case .failure(let error):
                print("Request failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = "Xác Nhận Mật Khẩu"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PasswordConfirmationViewController: UITextFieldDelegate {
    
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
