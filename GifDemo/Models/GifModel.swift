//
//  GifModel.swift
//  GifDemo
//
//  Created by omsairam on 26/02/22.
//

import Foundation

struct GifModel : Decodable {
    let type: String
    let id: String
    let slug: String
    let url: String
}
