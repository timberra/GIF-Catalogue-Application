//
//  NetworkManager.swift
//  GIF Catalogue App
//
//  Created by liga.griezne on 28/03/2024.
//

import Foundation

struct APIService {
    static let apiKey = "Zrwp79aFTpG5m66iUyMW32qoo73q95jL"
    static let baseURL = "https://api.giphy.com/v1/gifs"
    
    func fetchTrendingGIFs(completion: @escaping ([GIFData]?, Error?) -> Void) {
        guard let url = buildURL(endpoint: "trending", queryParams: ["api_key": APIService.apiKey]) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                print("Data found!")
                do {
                    print()
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(GIFResponse.self, from: data)
                    completion(response.data, nil)
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                    print(String(describing: error))
                    completion(nil, error)
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                print("No data found.")
                completion(nil, NSError(domain: "No data found", code: 0, userInfo: nil))
            }
        }.resume()
    }
    
    func searchGIFs(query: String, completion: @escaping ([GIFData]?, Error?) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil, NSError(domain: "Invalid query", code: 0, userInfo: nil))
            return
        }
        
        guard let url = buildURL(endpoint: "search", queryParams: ["api_key": APIService.apiKey, "q": encodedQuery]) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                print("Data found!")
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(GIFResponse.self, from: data)
                    completion(response.data, nil)
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                    print(String(describing: error))
                    completion(nil, error)
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                print("No data found.")
                completion(nil, NSError(domain: "No data found", code: 0, userInfo: nil))
            }
        }.resume()
    }
    
    private func buildURL(endpoint: String, queryParams: [String: String]) -> URL? {
        var components = URLComponents(string: "\(APIService.baseURL)/\(endpoint)")
        components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}

struct GIFResponse: Codable {
    let data: [GIFData]?
}






