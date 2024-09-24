//
//  AsyncThumbnailView.swift
//  Test
//
//  Created by Raymond Kelly on 9/23/24.
//

import SwiftUI

struct AsyncThumbnailView: View {
    
    var item: FlickrFeedItem
    
    var body: some View {
        NavigationLink {
            DetailedView(item: item)
        } label: {
            content
        }
    }
    
    private var content: some View {
        AsyncImage(
            url: URL(string: item.mediaURL),
            transaction: Transaction(animation: .easeInOut)
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .transition(.opacity)
            case .failure:
                errorView
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 100, height: 100)
        .background(Material.thin)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
    
    private var errorView: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(Color.yellow)
    }
}

// MARK: Previews
#Preview {
    let item = FlickrFeedItem(mediaURL: "https://live.staticflickr.com/65535/54013510363_96e701ec86_m.jpg")
    return AsyncThumbnailView(item: item)
}

#Preview {
    let item = FlickrFeedItem(mediaURL: "error")
    return AsyncThumbnailView(item: item)
}
