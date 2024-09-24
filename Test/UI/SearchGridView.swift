//
//  SearchGridView.swift
//  Test
//
//  Created by Raymond Kelly on 9/23/24.
//

import SwiftUI

struct SearchGridView: View {
   
    @State var vm = ViewModel()
    
    var body: some View {
        content
            .keyboardDismissal()
            .onChange(of: vm.searchText) { oldValue, newValue in
                vm.searchService.searchText = newValue
            }
    }
    
    private var content: some View {
        NavigationStack {
            VStack {
                SearchBarView(searchText: $vm.searchText)
                GridView(items: $vm.searchService.searchResults)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SearchGridView()
}


extension SearchGridView {
    
    @Observable final class ViewModel {
        var searchText: String = ""
        var searchService = SearchService()
    }
    
}

struct SearchBarView: View {
    
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        content
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.gray.opacity(0.1))
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    
                    TextField("Search Flickr", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                        .padding(.vertical, 10)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1),radius: 4, x: 0, y: 2)
                .frame(maxWidth: isFocused ? .infinity : 180)
                .animation(.easeInOut(duration: 0.3), value: isFocused)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
    }
}
