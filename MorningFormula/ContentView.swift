//
//  ContentView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/2/23.
//

import SwiftUI
import PhotosUI


struct ContentView: View {
    
    @ObservedObject var vm = CalendarManager.instance
    @ObservedObject var userManager = UserManager.instance
    @State var hasFinishedOnboarding = false
    
    var body: some View {
            if userManager.signedIn {
                let _ = userManager.hasUserFinishedOnboarding { hasFinished in
                    self.hasFinishedOnboarding = hasFinished

                }
                if hasFinishedOnboarding {
                    NavigationStack {
                        
                        TabBarView()
                    }
                    
                } else {
                    NavigationStack {
                        ProfileOnboardingView()
                    }
                }
            } else {
                SignUpView()

            }

//        }
        
//        AddGoalView()
//            .padding()
        
//        NavigationStack {
//            ProfileOnboardingView()
//        }
        
//        TTSViewTryOut()
        
//        Onboarding()
//        CalendarView()
//        RoutineView(date: $vm.selectedDate, forward: vm.forward, backward: vm.backward)
//        GeometryReader { geo in
//        Home()
//        CalendarWeekCarousel()
//            SwipingWeekView()
//            PlanBView()
            //        TaskWeekView()
//                    PlannerView()
//                    WeekView(geo: geo)
            //        TabBarView()
            //        ProfileOnboardingView()
//        }
    }
    
//
//    var body: some View {
//        VStack {
//
//            imagePicker
//            list
//
//        }
//        .padding()
//
//        .onChange(of: profile.selectedImage) { newValue in
//            if let newValue = newValue {
//                Task {
//                         newValue.loadTransferable(type: Data.self, completionHandler: { result in
//
//                            do {
//
//                            if let imageData = try result.get() {
//                                let image = UIImage(data: imageData) ?? UIImage()
//                                self.profile.images.append(image)
//                            }
//                            } catch {
//                                print(error.localizedDescription)
//                            }
//                                                                                })
//
//                }
//            }
//        }
//    }
    
//    private var imagePicker: some View {
//        PhotosPicker(selection: $profile.selectedImage) {
//            Text("ImagePicker")
//        }
//    }
//
//    private var imagesList: some View {
//        List(profile.images, id: \.self) { image in
//            Image(uiImage: image)
//                .resizable()
//                .frame(width: 70, height: 70)
//        }
//    }
//
//    var list: some View {
//        ScrollView {
//            LazyVGrid(columns: createGridItems(), spacing: 15) {
//                ForEach(profile.images, id: \.self) { image in
//                    Image(uiImage: image)
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                }
//            }
//            .padding()
//        }
//    }
//
//    func createGridItems() -> [GridItem] {
//        let gridItemLayout = [GridItem(.adaptive(minimum: 60))]
//        return gridItemLayout
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
