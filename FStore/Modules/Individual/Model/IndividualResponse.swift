//
//  IndividualResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct IndividualResponse: Decodable {
    var pending: Int?
    var shipping: Int?
    var purchased: Int?
}
