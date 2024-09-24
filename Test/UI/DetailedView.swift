//
//  DetailedView.swift
//  Test
//
//  Created by Raymond Kelly on 9/23/24.
//

import SwiftUI

struct DetailedView: View {
    
    // would be in a Date Format helper or String extension
    private let isoFormatter = ISO8601DateFormatter()
    var item: FlickrFeedItem
    
    var body: some View {
        VStack {
            imageView
            
            // would handle this differently with more time
            HTMLText(htmlContent: item.description)
            Text(item.author)
            Text(isoFormatter.date(from: item.published)?.formatted() ?? "")
        }
        .navigationTitle(item.title)
    }
    
    private var imageView: some View {
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
                    .aspectRatio(contentMode: .fit)
                    .transition(.opacity)
            case .failure:
                errorView
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 300, height: 300)
        .background(Material.thin)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
    
    private var errorView: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(Color.yellow)
    }
}

struct HTMLText: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // Allow multiline text
        label.textAlignment = .left // Align text to the left
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        // Convert the HTML string into NSAttributedString
        guard let data = htmlContent.data(using: .utf8) else { return }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            uiView.attributedText = attributedString
        } else {
            uiView.text = htmlContent // Fallback to raw HTML text if parsing fails
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            HTMLText(htmlContent: "<b>This is bold text</b><br/><i>This is italic text</i><br/><u>This is underlined text</u>")
                .padding()
        }
    }
}
