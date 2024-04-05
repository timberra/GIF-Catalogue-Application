//
//  GiphyItem.swift
//  GIF Catalogue App
//
//  Created by liga.griezne on 28/03/2024.
//

import Foundation

struct GIFData: Codable {
    let type: String?
    let id: String?
    let url: String?
    let slug: String?
    let bitlyGifURL: String?
    let bitlyURL: String?
    let embedURL: String?
    let username: String?
    let source: String?
    let title: String?
    let rating: String?
    let contentURL: String?
    let sourceTLD: String?
    let sourcePostURL: String?
    let isSticker: Int?
    let importDatetime: String?
    let trendingDatetime: String?
    let images: Images?
    let user: User?
    let analyticsResponsePayload: String?
    let analytics: Analytics?
    let altText: String?
    
    enum CodingKeys: String, CodingKey {
        case type, id, url, slug, username, source, title, rating, user, images
        case bitlyGifURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case analyticsResponsePayload = "analytics_response_payload"
        case analytics
        case altText = "alt_text"
    }
}

struct Images: Codable {
    let original: Original?
}

struct Original: Codable {
    let height: String?
    let width: String?
    let size: String?
    let url: String?
}

struct User: Codable {
    
}

struct Analytics: Codable {
    
}
