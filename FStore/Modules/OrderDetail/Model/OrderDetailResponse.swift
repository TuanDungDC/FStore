//
//  OrderDetailResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct OrderDetailResponse: Decodable {
    var title: String?
    var orderId: Int?
    var orderDate: String?
    var orderStatus: Int?
    var name: String?
    var phone: Int?
    var street: String?
    var communeWardTown: String?
    var district: String?
    var provinceCity: String?
    var shippingMethod: Int?
    var paymentMethod: Int?
    var products: [ProductResponse]?
    var provisionalPrice: Float?
    var transportFee: Float?
    var totalPrice: Float?
}
