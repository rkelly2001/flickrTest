//
//  GridView.swift
//  Test
//
//  Created by Raymond Kelly on 9/23/24.
//

import SwiftUI

struct GridView: View {
    
    @Binding var items: [FlickrFeedItem]

    private let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                // Loop through the image data and create grid items
                ForEach(items) { item in
                    VStack {
                        AsyncThumbnailView(item: item)
                    }
                }
            }
            .padding()
        }
    }
}

//MARK: Previews
private struct MockGridView: View {
    @State var items = [
        FlickrFeedItem(mediaURL: "https://live.staticflickr.com/65535/54013510363_96e701ec86_m.jpg"),
        FlickrFeedItem(mediaURL: "https://live.staticflickr.com/65535/54013510363_96e701ec86_m.jpg"),
        FlickrFeedItem(mediaURL: "https://live.staticflickr.com/65535/54013510363_96e701ec86_m.jpg")
    ]
    
    var body: some View {
        GridView(items: $items)
    }
}

#Preview {
    MockGridView()
}
