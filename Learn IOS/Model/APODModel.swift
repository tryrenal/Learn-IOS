//
//  APODModel.swift
//  Learn IOS
//
//  Created by redveloper on 3/11/25.
//

import Foundation

struct APODModel: Codable, Hashable{
    let title: String
    let explanation: String
    let url: String
    let copyright: String
    let date: String
    let hdurl: String
}
