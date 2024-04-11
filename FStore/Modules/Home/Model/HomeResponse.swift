//
//  HomeResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//


import UIKit

struct HomeResponse: Decodable {
    var id: Int?
    var title: String?
    var banner: String?
    var products: [ProductResponse]?
}
