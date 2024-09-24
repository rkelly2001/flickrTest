//
//  SearchService.swift
//  Test
//
//  Created by Raymond Kelly on 9/23/24.
//

import Foundation
import Combine

@Observable
final class SearchService {
    
    @ObservationIgnored @Published var searchText: String = ""
    var searchResults: [FlickrFeedItem] = []
    var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        // normally I would put this in a extension Set<AnyCancellable> mutating dispose func to safely tear down
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    init() {
        // Setup the pipeline
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { query in
                self.makeWebSafe(query)
            }
            .flatMap { debouncedQuery in
                self.fetchFlickrFeed(for: debouncedQuery)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = "Error: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { images in
                self.searchResults = images
            }
            .store(in: &cancellables)
    }
    
    // make sure query is web safe, could do more here in a real world senario
    private func makeWebSafe(_ query: String) -> String {
        return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
    }
    
    // simple implementation, could use publishers and handle errors
    private func fetchFlickrFeed(for tags: String) -> AnyPublisher<[FlickrFeedItem], Error> {
        guard !tags.isEmpty else {
            return Just([]) // Return empty array if no tags
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
                         //https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)) // Fail publisher for invalid URLs
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                let feed = try JSONDecoder().decode(FlickrFeed.self, from: data)
                return feed.items
            }
            .eraseToAnyPublisher()
    }
}
