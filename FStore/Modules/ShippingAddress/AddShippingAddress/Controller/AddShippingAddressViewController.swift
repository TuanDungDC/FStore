//
//  AddShippingAddressViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class AddShippingAddressViewController: UIViewController {

    var defaults = UserDefaults.standard
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        sv.contentSize.height = 550
        return sv
    }()
    
    lazy var nameTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Tên người nhận"
        tf.placeholderString = "Nhập họ & tên người nhận"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    lazy var phoneTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Số điện thoại"
        tf.placeholderString = "Nhập số điện thoại nhận hàng"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 14)
        tf.addDoneButtonOnKeyboard()
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    
    lazy var addressTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Địa chỉ nhận hàng"
        tf.placeholderString = "Nhập số nhà, tên đường..."
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    lazy var cityTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Tỉnh/ Thành phố"
        tf.placeholderString = "Chọn tỉnh/ thành phố"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 14)
        tf.tintColor = .clear
        return tf
    }()
    
    lazy var districtTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Quận/ Huyện"
        tf.placeholderString = "Chọn quận/ huyện"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 14)
        tf.tintColor = .clear
        return tf
    }()
    
    lazy var wardTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.labelString = "Phường/ Xã"
        tf.placeholderString = "Chọn phường/ xã"
        tf.labelFontSize = UIFont.systemFont(ofSize: 13)
        tf.textfieldFontSize = UIFont.systemFont(ofSize: 14)
        tf.tintColor = .clear
        return tf
    }()
    
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    lazy var addAddressButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Thêm Địa Chỉ", for: .normal)
        b.tintColor = .white
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleAddAddress), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 93).isActive = true

        bottomView.addSubview(addAddressButton)
        addAddressButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -28.5).isActive = true
        addAddressButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16).isActive = true
        addAddressButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16).isActive = true
        addAddressButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        scrollView.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1, constant: -32).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        scrollView.addSubview(phoneTextField)
        phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 44).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        scrollView.addSubview(addressTextField)
        addressTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 44).isActive = true
        addressTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        addressTextField.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        scrollView.addSubview(cityTextField)
        cityTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 44).isActive = true
        cityTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        cityTextField.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        scrollView.addSubview(districtTextField)
        districtTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 44).isActive = true
        districtTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        districtTextField.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        districtTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        scrollView.addSubview(wardTextField)
        wardTextField.topAnchor.constraint(equalTo: districtTextField.bottomAnchor, constant: 44).isActive = true
        wardTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        wardTextField.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        wardTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        provinceCityId = -1
        provinceCityName = ""
        
        districtId = -1
        districtName = ""
        
        communeWardTownId = -1
        communeWardTownName = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cityTextField.text = provinceCityName
        districtTextField.text = districtName
        wardTextField.text = communeWardTownName
        
        if !cityTextField.text!.isEmpty {
            cityTextField.labelColor = .black
            cityTextField.dividerColor = .lightGray
            cityTextField.errorLabelString = nil
        }
        if !districtTextField.text!.isEmpty {
            districtTextField.labelColor = .black
            districtTextField.dividerColor = .lightGray
            districtTextField.errorLabelString = nil
        }
        if !wardTextField.text!.isEmpty {
            wardTextField.labelColor = .black
            wardTextField.dividerColor = .lightGray
            wardTextField.errorLabelString = nil
        }
        
    }
    
    private func setupNavBar() {
        navigationItem.title = "Địa Chỉ Nhận Hàng"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = dismissButton
        
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleAddAddress() {
        if nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || addressTextField.text!.isEmpty || cityTextField.text!.isEmpty || districtTextField.text!.isEmpty || wardTextField.text!.isEmpty {
            if nameTextField.text!.isEmpty {
                nameTextField.errorLabelString = "Vui lòng nhập tên"
                nameTextField.dividerColor = .red
                nameTextField.labelColor = .red
                
            }
            if phoneTextField.text!.isEmpty {
                phoneTextField.errorLabelString = "Vui lòng nhập số điện thoại"
                phoneTextField.dividerColor = .red
                phoneTextField.labelColor = .red
            }
            if addressTextField.text!.isEmpty {
                addressTextField.errorLabelString = "Vui lòng nhập địa chỉ"
                addressTextField.dividerColor = .red
                addressTextField.labelColor = .red
            }
            if cityTextField.text!.isEmpty {
                cityTextField.errorLabelString = "Vui lòng chọn tỉnh/ thành phố"
                cityTextField.dividerColor = .red
                cityTextField.labelColor = .red
            }
            if districtTextField.text!.isEmpty {
                districtTextField.errorLabelString = "Vui lòng chọn quận/ huyện"
                districtTextField.dividerColor = .red
                districtTextField.labelColor = .red
            }
            if wardTextField.text!.isEmpty {
                wardTextField.errorLabelString = "Vui lòng chọn phường/ xã"
                wardTextField.dividerColor = .red
                wardTextField.labelColor = .red
            }
        }
        else if !phoneTextField.text!.isValidPhone() {
            let alertController = UIAlertController(title: "Lỗi", message: "Số điện thoại không hợp lệ", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
            alertController.addAction(closeAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else {
            self.addAddress()
        }
    }
    
    private func addAddress() {
        guard let url = URL(string: ADD_SHIPPING_ADDRESS_API_URL) else { return }
        let parameters: Parameters = ["recipient_name": nameTextField.text!, "phone_number": phoneTextField.text!, "street": addressTextField.text!, "province_city_id": provinceCityId, "district_id": districtId, "commune_ward_town_id": communeWardTownId, "user_id": defaults.value(forKey: Keys.id)!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            SVProgressHUD.dismiss()
            if let data = response.data {
                do {
                    if let value = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        let error = value["error"] as? Bool
                        if error == false {
                            self.dismiss(animated: true, completion: nil)
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
}


extension AddShippingAddressViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == cityTextField {
            let provinceCity = ProvinceCityTableViewController()
            let navigation = UINavigationController(rootViewController: provinceCity)
            DispatchQueue.main.async {
                self.present(navigation, animated: true, completion: nil)
            }
            return false
        }
        
        if textField == districtTextField {
            let district = DistrictTableViewController()
            let navigation = UINavigationController(rootViewController: district)
            DispatchQueue.main.async {
                self.present(navigation, animated: true, completion: nil)
            }
            return false
        }
        
        if textField == wardTextField {
            let communeWardTown = CommuneWardTownTableViewController()
            let navigation = UINavigationController(rootViewController: communeWardTown)
            DispatchQueue.main.async {
                self.present(navigation, animated: true, completion: nil)
            }
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            nameTextField.dividerColor = MAIN_COLOR
            nameTextField.dividerHeight = 2
        }
        if textField == phoneTextField {
            phoneTextField.dividerColor = MAIN_COLOR
            phoneTextField.dividerHeight = 2
        }
        if textField == addressTextField {
            addressTextField.dividerColor = MAIN_COLOR
            addressTextField.dividerHeight = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            nameTextField.dividerColor = .lightGray
            nameTextField.dividerHeight = 1
        }
        if textField == phoneTextField {
            phoneTextField.dividerColor = .lightGray
            phoneTextField.dividerHeight = 1
        }
        if textField == addressTextField {
            addressTextField.dividerColor = .lightGray
            addressTextField.dividerHeight = 1
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if textField == nameTextField {
            if (text != nil) {
                nameTextField.errorLabelString = nil
                nameTextField.dividerColor = MAIN_COLOR
                nameTextField.labelColor = .black
            }
        }
        if textField == phoneTextField {
            if (text != nil) {
                phoneTextField.errorLabelString = nil
                phoneTextField.dividerColor = MAIN_COLOR
                phoneTextField.labelColor = .black
            }
        }
        if textField == addressTextField {
            if (text != nil) {
                addressTextField.errorLabelString = nil
                addressTextField.dividerColor = MAIN_COLOR
                addressTextField.labelColor = .black
            }
        }
        if textField == cityTextField {
            if (text != nil) {
                cityTextField.errorLabelString = nil
                cityTextField.dividerColor = MAIN_COLOR
                cityTextField.labelColor = .black
            }
        }
        if textField == districtTextField {
            if (text != nil) {
                districtTextField.errorLabelString = nil
                districtTextField.dividerColor = MAIN_COLOR
                districtTextField.labelColor = .black
            }
        }
        if textField == wardTextField {
            if (text != nil) {
                wardTextField.errorLabelString = nil
                wardTextField.dividerColor = MAIN_COLOR
                wardTextField.labelColor = .black
            }
        }
        return true
    }
    
    
}

