//
//  iTunesStruct.swift
//  mini-iTunes2
//
//  Created by Howe on 2023/3/21.
//

import Foundation

struct iTunesItem: Codable {
    let artistName: String
    let collectionName: String
    let trackName: String
    let artworkUrl100: URL
    let trackId: Int
    let artistViewUrl: String
    let collectionViewUrl: String
    let previewUrl: String
    let releaseDate: String
}

// 所有資料
struct SearchResponse:Codable{
    let results:[iTunesItem]
}
