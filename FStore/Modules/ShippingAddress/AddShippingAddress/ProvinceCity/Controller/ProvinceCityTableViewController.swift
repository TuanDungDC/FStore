//
//  ProvinceCityTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire

var provinceCityId: Int = -1
var provinceCityName: String = ""

class ProvinceCityTableViewController: UITableViewController {
    
    private let cellId = "cellId"
    var provincesCities: [ProvinceCityResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        tableView.register(ProvinceCityTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        
        fetchData()
        
    }
    
    private func setupNavBar() {
        navigationItem.title = "Tỉnh/Thành phố"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchData() {
        guard let url = URL(string: PROVINCE_CITY_API_URL) else { return }
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let provincesCities = try decoder.decode([ProvinceCityResponse].self, from: data)
                    self.provincesCities = provincesCities
                    self.tableView.reloadData()
                } catch let err {
                    print(err)
                }
            } else if let error = response.error {
                print(error)
            }
        }
    }
}

extension ProvinceCityTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provincesCities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProvinceCityTableViewCell
        cell.provinceCity = provincesCities?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = provincesCities?[indexPath.row].id, let name = provincesCities?[indexPath.row].name {
            
            provinceCityId = id
            provinceCityName = name
            
            districtId = -1
            districtName = ""
            
            communeWardTownId = -1
            communeWardTownName = ""
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
