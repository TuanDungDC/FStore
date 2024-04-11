//
//  OrderResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct OrderResponse: Decodable {
    var orderId: Int?
    var orderName: String?
    var orderDate: String?
    var orderStatus: Int?
    var error: Int?
}
