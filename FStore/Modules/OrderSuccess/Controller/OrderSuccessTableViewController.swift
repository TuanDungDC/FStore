//
//  OrderSuccessCollectionViewController.swift
//  FStore
//
//  Created by Nguyễn Hải Âu on 3/16/20.
//  Copyright © 2020 Nguyễn Hải Âu. All rights reserved.
//

import UIKit
import Material
import Alamofire

class OrderSuccessCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var orders: [OrderResponse]? {
        didSet {
            if let count = orders?.count {
                if count <= 0 {
                    setupCollectionViewIsEmpty()
                }
            }
        }
    }
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.navigationItem.title = "Thành Công"
        collectionView.register(OrderSuccessCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        setupNavBar()
        fetchData()
    }
    
    private func setupCollectionViewIsEmpty() {
        let view = EmptyView()
        view.noticeString = "Bạn chưa có đơn hàng nào."
        collectionView.backgroundView = view
    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: Icon.arrowBack, style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchData() {
        guard let url = URL(string: ORDER_SUCCESS_API_URL) else { return }
        let parameters: Parameters = ["user_id": defaults.value(forKey: Keys.user_id)!]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let orders = try decoder.decode([OrderResponse].self, from: data)
                        self.orders = orders
                        self.collectionView.reloadData()
                    }
                    catch let err {
                        print(err)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OrderSuccessCollectionViewCell
        cell.order = orders?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let orderDetailViewController = OrderDetailViewController()
        orderDetailViewController.orderId = orders?[indexPath.item].orderId
        self.navigationController?.pushViewController(orderDetailViewController, animated: true)
    }
    
}


