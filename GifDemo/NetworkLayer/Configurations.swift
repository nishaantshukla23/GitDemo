//
//  Configuration.swift
//  GifDemo
//
//  Created by omsairam on 26/02/22.
//

import Foundation

struct Configuration {
    
    static let baseUrl          = "https://api.giphy.com/v1/gifs/"
    
    static let giphyAPIkey          = "ZpLjJRPShF22Djs7J2F7iEowUAO7Pf4O"
    
    static let pageLimit    = 20
    
    static func checkConfiguration() {
        
        if baseUrl.isEmpty || giphyAPIkey.isEmpty {
            fatalError("""
                Invalid configuration found
            """)
        }
    }
}

enum EndPoint: String {
        
    case search         =   "search"
    
    case fetch          =   "trending"
}
