//
//  GiphyItem.swift
//  GIF Catalogue App
//
//  Created by liga.griezne on 28/03/2024.
//

import Foundation

struct GIFData: Codable {
    let images: Images?
    enum CodingKeys: String, CodingKey {
        case images
    }
}
struct Images: Codable {
    let original: Original?
}
struct Original: Codable {
    let url: String?
}

