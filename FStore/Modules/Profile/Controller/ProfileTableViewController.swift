//
//  ProfileTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//


import UIKit
import SVProgressHUD
import Alamofire
import ActionSheetPicker_3_0

class ProfileTableViewController: UITableViewController {
    
    private let cellId = "cellId"
    private let cellId2 = "cellId2"
    let defaults = UserDefaults.standard
    
    var name = ""
    var phone = ""
    var email = ""
    var gender = ""
    var birthday = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId2)
    }
    
    private func setupNavBar() {
        navigationItem.title = "Thông Tin Tài Khoản"
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        let saveButton = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
        
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Đóng", style: .default, handler: nil)
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showVerificationAlert(title: String, message: String, phone: String) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Huỷ", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        })
        let verifyAction = UIAlertAction(title: "Xác Minh", style: .default, handler: { (action) in
            self.sendVerificationCode(phone: phone)
        })
        alertControl.addAction(cancelAction)
        alertControl.addAction(verifyAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    private func sendVerificationCode(phone: String) {
        guard let url = URL(string: VERIFY_API_URL) else { return }
        let parameters: Parameters = ["phone": phone]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { [unowned self] response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                           let error = json[Keys.error] as? Bool, error == true {
                            if let message = json[Keys.message] as? String {
                                self.showAlert(title: "Có lỗi xảy ra", message: message)
                            }
                        } else {
                            let verification = VerificationViewController()
                            verification.phone = phone
                            verification.type = 2
                            self.navigationController?.pushViewController(verification, animated: true)
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
    
    private func showDatePicker(_ sender: UITextField) {
        let datePicker = ActionSheetDatePicker(title: "Chọn Ngày Sinh", datePickerMode: .date, selectedDate: Date(), doneBlock: { picker, date, origin in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            sender.text = formatter.string(from: date as! Date)
            self.birthday = sender.text!
            return
            
        },cancel: {
            
            picker in
            return
            
        }, origin: sender)
        
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        datePicker?.minimumDate = .none
        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
        datePicker?.locale = Locale(identifier: "vi")
        
        let doneButton = UIBarButtonItem(title: "Xong", style: .done, target: nil, action: nil)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: nil, action: nil)
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        
        datePicker?.setDoneButton(doneButton)
        datePicker?.setCancelButton(cancelButton)
        datePicker?.toolbarBackgroundColor = MAIN_COLOR
        datePicker?.toolbarButtonsColor = .white
        datePicker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        datePicker?.show()
    }
    
    @objc private func handleSave() {
        
        if name == "" {
            showAlert(title: "Lỗi", message: "Vui lòng nhập tên người dùng")
            return
        }
        
        let accountType = "\(defaults.value(forKey: Keys.accountType) ?? "")"
        
        if Int(accountType) == 0 {
            if phone == "" {
                showAlert(title: "Lỗi", message: "Số điện thoại không được để trống")
                return
            }
            if phone != "" {
                if !phone.isValidPhone() {
                    showAlert(title: "Lỗi", message: "Số điện thoại không hợp lệ")
                    return
                }
            }
        }
        
        if gender == "" {
            gender = "-1"
        }
        
        if image != nil {
            self.uploadImg()
        }
            
        else {
            updateUser()
        }
        
    }
    
    func saveUser(_ user: UserResponse) {
        defaults.set(user.id, forKey: Keys.id)
        defaults.set(user.name, forKey: Keys.name)
        defaults.set(user.phone, forKey: Keys.phone)
        defaults.set(user.email, forKey: Keys.email)
        defaults.set(user.gender, forKey: Keys.gender)
        defaults.set(user.avatarUrl, forKey: Keys.avatarUrl)
        defaults.set(user.birthday, forKey: Keys.birthday)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func updateUI() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        guard let url = URL(string: GET_USER_INFO) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { [weak self] response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let user = try JSONDecoder().decode(UserResponse.self, from: data)
                        self?.saveUser(user)
                        SVProgressHUD.dismiss()
                    } catch {
                        print("JSON Decoding Error: \(error.localizedDescription)")
                    }
                } else {
                    print("No data received from the server.")
                }
            case .failure(let error):
                print("Request failed: \(error.localizedDescription)")
            }
        }
    }

    
    func uploadImg() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        let imageData = image?.jpegData(compressionQuality: 1)
        let params: [String: Any] = ["userId": defaults.value(forKey: Keys.id)!]
        AF.upload(multipartFormData: { multipartFormData in
            if let data = imageData {
                multipartFormData.append(data, withName: "file", fileName: "image_file.jpg", mimeType: "image/jpg")
            }
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: UPLOAD_IMAGE_API_URL)
        .uploadProgress { progress in
            //print("Upload Progress: \(progress.fractionCompleted)")
        }
        .response { response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let data):
                if let data = data {
                    // Handle the response data
                    print("Upload success with response data: \(data)")
                    self.updateUser()
                }
            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUser() {
        let accountType = "\(defaults.value(forKey: Keys.accountType) ?? "")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the date format to your needs
        let birthdayDate = dateFormatter.date(from: birthday) ?? Date()
        guard let url = URL(string: UPDATE_USER_INFO_API_URL) else { return }
        let parameters: [String: Any] = [
            "id": defaults.value(forKey: Keys.id) ?? "",
            "name": name,
            "phone": phone,
            "gender": gender,
            "birthday": dateFormatter.string(from: birthdayDate),
            "accountType": accountType
        ]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                if let data = data, let value = try? JSONSerialization.jsonObject(with: data) as? NSDictionary {
                    let error = value["error"] as? Bool
                    if error == false {
                        self.updateUI()
                        SVProgressHUD.dismiss()
                        if let activePhoneNumber = value["activePhoneNumber"] as? Bool, activePhoneNumber {
                            self.showVerificationAlert(title: "Thay Đổi Số Điện Thoại", message: "Chúng tôi sẽ gửi mã xác thực đến số điện thoại \(self.phone). Vui lòng xác thực để đảm bảo số điện thoại này là đúng!", phone: self.phone)
                        }
                    } else {
                        let message = value["message"] as? String
                        self.showAlert(title: "Có lỗi xảy ra", message: message ?? "Unknown error")
                        SVProgressHUD.dismiss()
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Network Error", message: error.localizedDescription)
                SVProgressHUD.dismiss()
            }
        }
    }
}


extension ProfileTableViewController: UITextFieldDelegate {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileTableViewCell

            cell.textField.tag = indexPath.row
            
            if indexPath.row == 0 {
                cell.titleLabel.text = "Tên người dùng"
                cell.textField.text = defaults.value(forKey: Keys.name) as? String
                name = cell.textField.text!
                cell.textField.returnKeyType = .done
                cell.setupTextField(isHidden: false)
            }
            
            if indexPath.row == 1 {
                let accountType = "\(defaults.value(forKey: Keys.accountType) ?? "")"
                if (Int(accountType) != 0) {
                    cell.titleLabel.text = "Email"
                    let e = "\(defaults.value(forKey: Keys.email) ?? "")"
                    cell.textField.textColor = .darkGray
                    cell.textField.isUserInteractionEnabled = false
                    email = cell.textField.text!
                    cell.textField.text = e
                    cell.textField.keyboardType = .emailAddress
                    cell.setupTextField(isHidden: false)
                }
                else {
                    cell.titleLabel.text = "Số điện thoại"
                    let p = "\(defaults.value(forKey: Keys.phone) ?? "")"
                    if p != "" {
                        cell.textField.text = "0\(p)"
                    }
                    cell.textField.keyboardType = .numberPad
                    cell.textField.addDoneButtonOnKeyboard()
                    phone = cell.textField.text!
                    cell.setupTextField(isHidden: false)
                }
            }
            
            if indexPath.row == 2 {
                cell.titleLabel.text = "Tài khoản"
                let accountType = "\(defaults.value(forKey: Keys.accountType) ?? "")"
                cell.textField.text = accountType
                if cell.textField.text == "0" {
                    cell.textField.text = "Tài khoản từ SĐT"
                }
                if cell.textField.text == "1" {
                    cell.textField.text = "Tài khoản Facebook"
                }
                if cell.textField.text == "2" {
                    cell.textField.text = "Tài khoản Google"
                }
                if cell.textField.text == "3" {
                    cell.textField.text = "Tài khoản Twitter"
                }
                cell.textField.textColor = .darkGray
                cell.textField.isUserInteractionEnabled = false
                cell.setupTextField(isHidden: false)
            }
            
            if indexPath.row == 3 {
                cell.titleLabel.text = "Giới tính"
                
                let gder = "\(defaults.value(forKey: Keys.gender) ?? "")"
                if gder == "0" {
                    cell.maleButton.isOn = true
                }
                if gder == "1" {
                    cell.femaleButton.isOn = true
                }
                gender = gder
                cell.setupRadioButton(isHidden: false)
                cell.profileTableViewController = self
            }
            
            if indexPath.row == 4 {
                cell.titleLabel.text = "Ngày sinh"
                let date = Date()
                let bday = defaults.value(forKey: Keys.birthday) as? String ?? ""
                if bday != "" {
                    let dateString = bday
                    let dateFormatter = date.getFormattedDate(string: dateString)
                    cell.textField.text = dateFormatter
                }
                birthday = cell.textField.text!
                cell.textField.placeholder = "Hãy chọn ngày sinh của bạn"
                cell.setupTextField(isHidden: false)
            }
            
            cell.textField.delegate = self
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath)
            let accountType = "\(defaults.value(forKey: Keys.accountType) ?? "")"
            if Int(accountType) != 0 {
                cell.textLabel?.textColor = .lightGray
            }
            cell.textLabel?.text = "Đổi mật khẩu"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accountType = "\(defaults.value(forKey: Keys.accountType) ?? "")"
        if indexPath.section == 1 {
            if Int(accountType) == 0 {
                let vc = PasswordConfirmationViewController()
                let navBar = UINavigationController(rootViewController: vc)
                DispatchQueue.main.async {
                    self.present(navBar, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = ProfileHeaderView()
            let avatarUrl = ("\(defaults.value(forKey: Keys.avatarUrl) ?? "")")
            let name = ("\(defaults.value(forKey: Keys.name) ?? "")")
            let email = ("\(defaults.value(forKey: Keys.email) ?? "")")
            let phone = ("\(defaults.value(forKey: Keys.phone) ?? "")")
            DispatchQueue.main.async {
                headerView.avatarImageView.sd_setImage(with: URL(string: avatarUrl), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached, context: nil)
                headerView.backgroundImageView.sd_setImage(with: URL(string: avatarUrl), placeholderImage: #imageLiteral(resourceName: "default-banner"), options: .refreshCached, context: nil)
                headerView.nameLabel.text = name
                if email != "" {
                    headerView.emailLabel.text = email
                }
                else {
                    headerView.emailLabel.text = "0\(phone)"
                }
            }
            headerView.profileTableViewController = self
            return headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 208
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        
        var kActualText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        kActualText = kActualText.trimmingCharacters(in: .whitespaces)
        
        if textField.tag == 0
        {
            name = kActualText
        }
        else if textField.tag == 1
        {
            let accountType = "\(defaults.value(forKey: Keys.accountType) ?? "")"
            if (Int(accountType) == 0) {
                phone = kActualText
            }
        }
        else if textField.tag == 3
        {
            gender = kActualText
        }
        else if textField.tag == 4
        {
            birthday = kActualText
        }
        else
        {
            print("It is nothing")
        }
        
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 4 {
            showDatePicker(textField)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
}
