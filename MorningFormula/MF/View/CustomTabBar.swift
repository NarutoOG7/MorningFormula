//
//  CustomTabBar.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/18/23.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selection: Int
        
    var body: some View {
        ZStack {
//            CustomCurvedBar()
            ZStack {
                
                VStack {
                    HStack(alignment: .lastTextBaseline) {
                        CustomTabItem(iconName: "testtube.2", label: "Formula", selection: $selection, tag: 0) {
                            FormulaView()
                        }
                        CustomTabItem(iconName: "calendar", label: "Today", selection: $selection, tag: 1) {
                            Today()
                        }
                        CustomTabItem(iconName: "target", label: "Goals", selection: $selection, tag: 2) {
                            Goals()
                        }
                        CustomTabItem(iconName: "gear", label: "Settings", selection: $selection, tag: 3) {
                            SettingsView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    //                    .padding()
                    //                    .background(
                    //                        CustomCurvedBar()
                    //                        RoundedRectangle(cornerRadius: 12)
                    //                            .stroke(lineWidth: 2)
                    //                            .padding()
                    //                            .frame(height: 100)
                    //
                    //                        )
                    
                    
                    //                    .background(
                    //                        GeometryReader { geo in
                    //                        Rectangle()
                    //                            .fill(Color(UIColor.systemGray2))
                    //                            .frame(width: geo.size.width, height: 0.5)
                    //                            .position(x: geo.size.width / 2, y: 0)
                    //
                    //                        }
                    //                    )
                    //                    .background(Color(UIColor.systemGray6))
                    //                    .overlay(
                    //                        GeometryReader { geo in
                    //                            Rectangle()
                    //                                .fill(Color.clear)
                    //                                .preference(key: TabBarPreferenceKey.self,
                    //                                            value: TabBarPreferenceData(tabBarBounds: geo.frame(in: .named("customTabBar"))))
                    //                        }
                    //                    )
         
                    
                }
                
                Circle()
                //                    .overlay(
                //                        CustomTabItem(iconName: "plus", label: "", selection: $selection, tag: 0)
                ////                                        .frame(height: 100)
                //                        //                .padding(.bottom, 25)
                //
                //                    )
                    .frame(width: 50)
                    .offset(y: -35)
                
                //                    .padding(.bottom, 50)
                //
                //                .frame(width: 50, height: 100, alignment: .bottom)
                
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            //            .overlayPreferenceValue(TabBarPreferenceKey.self) { preferences in
            //                return Rectangle().fill(Color.clear)
            //            }
            .overlayPreferenceValue(TabBarPreferenceKey.self) { (preferences: TabBarPreferenceData) in
                return GeometryReader { geo in
                    self.createTabBarContentOverlay(geo, preferences)
                }
            }
            .coordinateSpace(name: "customTabBar")
        }
        }
    
    private func createTabBarContentOverlay(_ geometry: GeometryProxy,
                                            _ preferences: TabBarPreferenceData) -> some View {
        let tabBarBounds = preferences.tabBarBounds != nil ? preferences.tabBarBounds! : .zero
        let contentToDisplay = preferences.tabBarItemData.first(where: { $0.tag == self.selection })
        
        return ZStack {
            if contentToDisplay == nil {
                Text("Empty View")
            } else {
                contentToDisplay!.content
            }
        }
        .frame(width: geometry.size.width,
               height: geometry.size.height - tabBarBounds.size.height,
               alignment: .center)
        .position(x: geometry.size.width / 2,
                  y: (geometry.size.height - tabBarBounds.size.height) / 2)
    }
}

#Preview {
    var selection: Int = 0
    var selectionBinding = Binding<Int>(get: { selection}, set: { selection = $0 })
    return CustomTabBar(selection: selectionBinding)
}

struct Placeholder {
    
}

struct TabBarItemData {
    var tag: Int
    var content: AnyView
}

struct TabBarPreferenceData {
    var tabBarBounds: CGRect? = nil
    var tabBarItemData: [TabBarItemData] = []
}

struct TabBarPreferenceKey: PreferenceKey {
    typealias Value = TabBarPreferenceData

    static var defaultValue: TabBarPreferenceData = TabBarPreferenceData()

    static func reduce(value: inout TabBarPreferenceData, nextValue: () -> TabBarPreferenceData) {
        if let tabBarBounds = nextValue().tabBarBounds {
            value.tabBarBounds = tabBarBounds
        }
        value.tabBarItemData.append(contentsOf: nextValue().tabBarItemData)
    }
}


struct CurvedBar: View {
    var body: some View {
        VStack {
            Spacer()

            GeometryReader { geometry in
                ZStack {
                    let cornerRadius: CGFloat = 0.1 * min(geometry.size.width, geometry.size.height)
                    let rectangleSize = CGSize(width: geometry.size.width, height: geometry.size.height)
                    let circleRadius: CGFloat = 0.15 * min(geometry.size.width, geometry.size.height)
                    let yOffset: CGFloat = 0.1 * min(geometry.size.width, geometry.size.height)

                    Path { path in
                        // Draw rectangle with curved top line around the circle
                        path.move(to: CGPoint(x: cornerRadius, y: 0))
                        path.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: 0, y: cornerRadius), radius: cornerRadius)

                        // Adjust the curve around the circle
                        let circleCenter = CGPoint(x: rectangleSize.width / 2, y: cornerRadius + yOffset)
                        path.addQuadCurve(to: CGPoint(x: rectangleSize.width - cornerRadius, y: 0), control: CGPoint(x: rectangleSize.width, y: 0))
                        path.addArc(tangent1End: CGPoint(x: rectangleSize.width, y: 0), tangent2End: CGPoint(x: rectangleSize.width, y: cornerRadius), radius: cornerRadius)

                        // Draw the rectangle
                        path.addLine(to: CGPoint(x: rectangleSize.width, y: rectangleSize.height - cornerRadius))
                        path.addArc(tangent1End: CGPoint(x: rectangleSize.width, y: rectangleSize.height), tangent2End: CGPoint(x: rectangleSize.width - cornerRadius, y: rectangleSize.height), radius: cornerRadius)
                        path.addLine(to: CGPoint(x: cornerRadius, y: rectangleSize.height))
                        path.addArc(tangent1End: CGPoint(x: 0, y: rectangleSize.height), tangent2End: CGPoint(x: 0, y: rectangleSize.height - cornerRadius), radius: cornerRadius)
                        path.closeSubpath()

                        // Draw the circle on top of the rectangle
                        Circle()
                            .frame(width: circleRadius * 2, height: circleRadius * 2)
                            .position(circleCenter)
                            .foregroundColor(Color.white)
                    }
                    .fill(style: FillStyle(eoFill: true))
                }
            }
            .background(Color.gray) // Optional: Add a background color to visualize the cutout

            Spacer()
        }
    }
}


enum FillRule {
    case nonZero
    case evenOdd
}
