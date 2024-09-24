//
//  FlickrImage.swift
//  Test
//
//  Created by Raymond Kelly on 9/23/24.
//

import Foundation
import SwiftUI

struct FlickrFeed: Codable {
    let title: String
    let description: String
    let modified: String
    let items: [FlickrFeedItem]
}

struct FlickrFeedItem: Codable {
    let title: String
    let media: [String: String]
    let description: String
    let published: String
    let author: String
    
    var mediaURL: String {
        return media["m"] ?? ""
    }
    
    init(title: String = "",
         mediaURL: String,
         description: String = "",
         published: String = "",
         author: String = ""
    ) {
        self.title = title
        self.media = ["m": mediaURL]
        self.description = description
        self.published = published
        self.author = author
    }
}

extension FlickrFeedItem: Identifiable {
    var id: String {
        mediaURL
    }
}
//
//struct FlickrImage: Codable, Identifiable {
//    let id: UUID
//    let title: String
//    let media: [String: String]
//    
//    var mediaURL: String {
//        return media["m"] ?? ""
//    }
//    
//    init(title: String = "", mediaURL: String) {
//        self.id = UUID()
//        self.title = title
//        self.media = ["m": mediaURL]
//    }
//}

