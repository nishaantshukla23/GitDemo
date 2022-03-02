//
//  GifNetworkManager.swift
//  GifDemo
//
//  Created by omsairam on 26/02/22.
//

import Foundation
import Alamofire

class GifNetworkManager {
    
    static let shared = GifNetworkManager()
    fileprivate var alamofireManager: Alamofire.SessionManager!

    fileprivate init() {
        let configuration = URLSessionConfiguration.default
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    /**
        Returns a url with our API key and search term
        - Parameter searchTerm: The string to search gifs of
        - Returns: URL of search term & api key
        */
        func urlBuilder(searchTerm: String) -> URL {
            let apikey = Configuration.giphyAPIkey
            var components = URLComponents()
               components.scheme = "https"
               components.host = "api.giphy.com"
               components.path = "/v1/gifs/search"
               components.queryItems = [
                   URLQueryItem(name: "api_key", value: apikey),
                   URLQueryItem(name: "q", value: searchTerm),
                   URLQueryItem(name: "limit", value: "10") // Edit limit to display more gifs
               ]
            return components.url!
        }
    
/**
     Fetches gifs from the Giphy api
    -Parameter searchTerm: What we should query gifs of.
    */
    func fetchGifs(searchTerm: String, completion: @escaping (_ response: GiphyResponse?) -> Void) {
        // Create a GET url request
        let url = urlBuilder(searchTerm: searchTerm)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Error fetching from Giphy: ", err.localizedDescription)
            }
            do {
                // Decode the data into array of Gifs
                DispatchQueue.main.async {
                    let object = try! JSONDecoder().decode(GiphyResponse.self, from: data!)
                    completion(object)
                }
            }
        }.resume()
    }
    
    
    func queryTrendingGifs(_ limit: Int, offset: Int, completionHandler:@escaping (_ gifs: GiphyResponse?, _ error: String?) -> Void) {
        
        alamofireManager.request(Configuration.baseUrl + "trending", method: .get, parameters: ["api_key" : Configuration.giphyAPIkey, "limit" : "\(limit)", "offset" : "\(offset)"], encoding: URLEncoding.default).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success( _):
                        // internet works.
                        do {
                            // Decode the data into array of Gifs
                            DispatchQueue.main.async {
                                let object = try! JSONDecoder().decode(GiphyResponse.self, from: response.data!)
                                completionHandler(object, nil)
                            }
                        }
                    
                        
                    case .failure(let error):
                        print(error)
//                        if let err = error as? Error, err == .NotConnectedToInternet {
//                            // no internet connection
//                        } else {
//                            // other failures
//                        }
                }
            
           
        })
    }
    
}


