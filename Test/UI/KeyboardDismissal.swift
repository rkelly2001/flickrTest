//
//  KeyboardDismissal.swift
//  Test
//
//  Created by Raymond Kelly on 9/23/24.
//

import SwiftUI

struct KeyboardDismissOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.clear)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

extension View {
    func keyboardDismissal() -> some View {
        self.modifier(KeyboardDismissOnTap())
    }
}
