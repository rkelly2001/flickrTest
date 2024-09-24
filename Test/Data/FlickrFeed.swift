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

