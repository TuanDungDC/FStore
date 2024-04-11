//
//  DistrictTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire

var districtId: Int = 0
var districtName: String = ""

class DistrictTableViewController: UITableViewController {
    
    private let cellId = "cellId"
    var districts: [DistrictResponse]?
    var districtsFiltered: [DistrictResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        tableView.register(DistrictTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        
        fetchData()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Quận/Huyện"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchData() {
        guard let url = URL(string: DISTRICT_API_URL) else { return }
        AF.request(url).responseDecodable(of: [DistrictResponse].self) { response in
            switch response.result {
            case .success(let districts):
                self.districts = districts
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DistrictTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let districtsFiltered = districts?.filter { $0.province_city_id == provinceCityId }
        self.districtsFiltered = districtsFiltered
        return self.districtsFiltered?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DistrictTableViewCell
        cell.district = districtsFiltered?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = districtsFiltered?[indexPath.row].id, let name = districtsFiltered?[indexPath.row].name {
            
            districtId = id
            districtName = name
            
            communeWardTownId = -1
            communeWardTownName = ""
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
