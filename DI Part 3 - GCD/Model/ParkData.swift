//
//  ParkData.swift
//  DI Part 3 - GCD
//
//  Created by 簡莉芯 on 2023/5/31.
//

import Foundation

struct ParkData: Codable {
    let limit: Int
    let offset: Int
    let count: Int
    let sort: String
    let results: [ParkInfo]
}
