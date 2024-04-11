//
//  OrderConfirmationResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct OrderConfirmationResponse: Decodable {
    var title: String?
    var products: [ProductResponse]?
    var id: Int?
    var name: String?
    var phone: Int?
    var street: String?
    var communeWardTown: String?
    var district: String?
    var provinceCity: String?
    var isDefault: Int?
    var formOfDelivery: Int?
    var paymentMethod: Int?
    var provisionalPrice: Float?
    var transportFee: Float?
}
