//
//  CommuneWardTownTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire

var communeWardTownId: Int = -1
var communeWardTownName: String = ""

class CommuneWardTownTableViewController: UITableViewController {
    
    private let cellId = "cellId"
    var communesWardsTowns: [CommuneWardTownResponse]?
    var communesWardsTownsFiltered: [CommuneWardTownResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        tableView.register(CommuneWardTownTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        
        fetchData()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Phường/Xã"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchData() {
        guard let url = URL(string: COMMUNE_WARD_TOWN_API_URL) else { return }
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let communesWardsTowns = try decoder.decode([CommuneWardTownResponse].self, from: data)
                    self.communesWardsTowns = communesWardsTowns
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

extension CommuneWardTownTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let communesWardsTownsFiltered = communesWardsTowns?.filter { $0.district_id == districtId }
        self.communesWardsTownsFiltered = communesWardsTownsFiltered
        return self.communesWardsTownsFiltered?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommuneWardTownTableViewCell
        cell.communeWardTown = communesWardsTownsFiltered?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = communesWardsTownsFiltered?[indexPath.row].id, let name = communesWardsTownsFiltered?[indexPath.row].name {
            
            communeWardTownId = id
            communeWardTownName = name
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
