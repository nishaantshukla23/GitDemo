//
//  Configuration.swift
//  GifDemo
//
//  Created by omsairam on 26/02/22.
//

import Foundation
import UIKit

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

struct Constants {
    static let cellPadding: Float = 5.0
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    static let Red = UIColor.init(red: 0.918, green: 0.263, blue: 0.208, alpha: 1.0)
    static let Green = UIColor.init(red: 0.204, green: 0.659, blue: 0.325, alpha: 1.0)
    
    static let noInternetOverlayTag: Int = 2000789
    static let dateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    static let nonTrendedDateTimeFormat = "0000-00-00 00:00:00"
    
    // adjust here
    static let searchResultsLimit: Int = 400
    static let preferredSearchRating = "pg"
    static let preferredImageType = "fixed_width_downsampled"
    static let trendedIconName = "trendedIcon"
    static let trendedIconSize: CGFloat = 15
}
