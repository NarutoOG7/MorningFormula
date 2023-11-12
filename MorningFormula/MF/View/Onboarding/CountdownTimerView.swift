//
//  CountdownTimerView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/25/23.
//

import SwiftUI
import SwiftUIIntrospect
//import DispatchIntrospection

//struct CountdownTimerView: View {
//
//    @State private var selectedHourIndex = 0
//    @State private var selectedMinuteIndex = 0
//
//    let hours = Array(0...24)
//    let minutes = Array(0...59)
//
//    var body: some View {
//
//        HStack {
//            hoursPicker
//            minutesPicker
//        }
//    }
//
//    private var hoursPicker: some View {
//        Picker(selection: $selectedHourIndex) {
//            ForEach(0..<hours.count) { index in
//                Text("\(hours[index])").tag(index)
//            }
//        } label: {
//            Text("Hours")
//        }
//        .pickerStyle(.wheel)
//        .frame(width: 100)
////        .clipped()
//
//    }
//
//    private var minutesPicker: some View {
//        Picker(selection: $selectedMinuteIndex) {
//            ForEach(0..<minutes.count) { index in
//                Text("\(minutes[index])").tag(index)
//            }
//        } label: {
//            Text("Minutes")
//        }
//        .pickerStyle(.wheel)
//        .frame(width: 100)
////        .clipped()
//
//    }
//}

struct CountdownTimerView: View {
    @State private var selectedHourIndex = 0
    @State private var selectedMinuteIndex = 0
    
    let color: Color
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(.clear)
                .frame(height: 35)
            VStack {
                HStack(spacing: -20) {
                    hoursPicker
                        .padding(.leading, -20)
                    
                    Text("hours")
                        .padding(.trailing, 30)
                    minutePicker
                    Text("min")
                        .padding(.trailing)
                }
            }
           

        }
//        .frame(width: 300)
    }
    
    private var hoursPicker: some View {
        Picker(selection: $selectedHourIndex, label: Text("Hours")) {
            ForEach(hours, id: \.self) { index in
                Text("\(index)").tag(index)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17), customize: { picker in
            picker.subviews[0].backgroundColor = UIColor.clear
            print(type(of: picker))
        })
        .frame(width: 100)
        .clipped()
        
    }
    
    private var minutePicker: some View {
        Picker(selection: $selectedMinuteIndex, label: Text("Minutes")) {
            ForEach(minutes, id: \.self) { minute in
                Text("\(minute)").tag(minute)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(width: 100)
        .clipped()
        
    }
    
    init(_ color: Color) {
        self.color = color
        UIPickerView.appearance().tintColor = .red
        
    }
}

struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerView(.red)
    }
}


//extension View {
//    public func introspectUIPickerView(customize: @escaping (UIPickerView) -> ()) -> some View {
//        return inject(UIKitIntrospectionView(
//            selector: { introspectionView in
//                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
//                    return nil
//                }
//                return Introspect.previousSibling(containing: UIPickerView.self, from: viewHost)
//            },
//            customize: customize
//        ))
//    }
//}
