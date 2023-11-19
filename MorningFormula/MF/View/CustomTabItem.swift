//
//  CustomTabItem.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/17/23.
//

import SwiftUI

struct CustomTabItem<Content: View>: View {
    
    let iconName: String
    let label: String
    
    let selection: Binding<Int>
    let tag: Int
    
    let content: () -> Content
    
    init(iconName: String,
         label: String,
         selection: Binding<Int>,
         tag: Int,
         @ViewBuilder _ content: @escaping () -> Content) {
        self.iconName = iconName
        self.label = label
        self.selection = selection
        self.tag = tag
        self.content = content
    }
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
//                .font(.title2)
                .frame(minWidth: 25, minHeight: 25)

            if label != "" {
                Text(label)
                    .font(.caption)
            }
        }
        .padding([.top, .bottom], 5) 
        .foregroundColor(fgColor())
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { 
            self.selection.wrappedValue = self.tag
        }
        .preference(key: TabBarPreferenceKey.self,
                        value: TabBarPreferenceData(
                            tabBarItemData: [TabBarItemData(tag: tag,
                                                            content: AnyView(self.content()))]))
    }
    
    private func fgColor() -> Color {
        return selection.wrappedValue == tag ? Color(UIColor.systemBlue) : Color(UIColor.systemGray)
    }
}

#Preview {
    CustomTabItem(iconName: "house", label: "Home", selection: .constant(1), tag: 1) {
        Today()
    }
        .previewLayout(.fixed(width: 80, height: 80))
}
