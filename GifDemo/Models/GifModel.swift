//
//  GifModel.swift
//  GifDemo
//
//  Created by omsairam on 26/02/22.
//

import Foundation

struct GifModel: Decodable {
    var type: String
    var id: String
    var slug: String
    var url: String
    var gifSources: GifImages

    enum CodingKeys: String, CodingKey {
        case gifSources = "images"
        case type, id, slug, url
    }
}


/// Array of Gif objects.
struct GiphyResponse: Decodable {
    var gifs: [GifModel]
    var pagination: Pagination
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
        case pagination
    }
}

/*
/// Contains giph properties
struct Gif: Decodable {
    var gifSources: GifImages
    enum CodingKeys: String, CodingKey {
        case gifSources = "images"
    }
    /// Returns download url of the originial gif
    func getGifURL() -> String{
        return gifSources.original.url
    }
}
 */
/// Stores the original Gif
struct GifImages: Decodable {
    var original: original
    enum CodingKeys: String, CodingKey {
        case original = "original"
    }
}

/// URL to data of Gif
struct original: Decodable {
    var url: String
}


// MARK: - Pagination
struct Pagination: Codable {
    let totalCount, count, offset: Int?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
