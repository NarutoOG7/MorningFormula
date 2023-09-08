//
//  SwipeArrayPlay.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/7/23.
//

import SwiftUI


struct Item: Identifiable {
    let id = UUID()
    let name: String
}

class SwipeViewModel: ObservableObject {
    @Published var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    // Implement your swipe logic here, e.g., moving items in the array
}

struct SwipeItemView: View {
    let item: Item

    var body: some View {
        Text(item.name)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
    }
}

struct SwipeArrayPlay: View {
    
        @ObservedObject var viewModel: SwipeViewModel

        var body: some View {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.items) { item in
                            SwipeItemView(item: item)
                        }
                    }
                    .frame(width: geometry.size.width)
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Handle the drag gesture to update the view as needed
                            viewModel.items = newItems
//                            for item in items {
//                                viewModel.items.append(item)
//                            }
                        }
                )
            }
        }
}

struct SwipeArrayPlay_Previews: PreviewProvider {
    static var previews: some View {
        SwipeArrayPlay(viewModel: SwipeViewModel(items: items))

    }
}

let items = [
    Item(name: "mon"),
    Item(name: "tue"),
    Item(name: "wed"),
    Item(name: "thu"),
    Item(name: "fri"),
    Item(name: "sat"),
    Item(name: "sun")
]

let newItems = [
    Item(name: "a"),
    Item(name: "b"),
    Item(name: "c"),
    Item(name: "d"),
    Item(name: "e"),
    Item(name: "f"),
    Item(name: "g")
]

