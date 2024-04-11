//
//  ProductResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct ProductResponse: Decodable {
    var id: Int?
    var orderId: Int?
    var name: String?
    var price: Float?
    var isSale: Int?
    var salePrice: Float?
    var thumbnailUrl: String?
    var rating: Double?
    var comment: Int?
    var quantity: Int?
    var attributeId: Int?
}
