//
//  Home.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/25/23.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var viewModel = HomeViewModel.instance
    
    @State var day = Date()
    @State var isDaySetByMidnight = true
    @State var wheelRotatesWithEOD = true
    @State var sleepTime = (start: 0.0, end: 8.0, duration: 8.0)
    

    @ObservedObject var addTaskViewModel = AddTaskViewModel.instance
    @ObservedObject var spotifyManager = SpotifyManager.instance
    
    var body: some View {
                NavigationStack {
        VStack {
            dayDefinitionSwitch
            wheelRotationSwitch
            timeView
            //                List {
            //                    ForEach(viewModel.ekEvents, id: \.eventIdentifier) { event in
            //                        Text(event.title)
            //                    }.onDelete { indexSet in
            //                        viewModel.ekEvents.remove(atOffsets: indexSet)
            //                    }
            //                }
            DayView(color: .white, day: $day)
                .padding(.horizontal)
            //                sleepAdjuster
            
        }
        //        }
        
        
        .toolbar {
            ToolbarItemGroup {
                HStack {
                    Button {
                        spotifyManager.getRecommendedSong { song in
                            viewModel.recommendedSong = song
                            viewModel.showRecommendedSong = true
                        }
                    } label: {
                        Image("SpotifyIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.toolbarAddTapped()
                    } label: {
                        Text("+")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button {
//                    viewModel.toolbarAddTapped()
//                } label: {
//                    Text("+")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                }
//            }
//            
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    viewModel.toolbarAddTapped()
//                } label: {
//                    Image("SpotifyIcon")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                }
//            }

        }
        
        .confirmationDialog("", isPresented: $viewModel.addActionIsVisible) {
            NavigationLink {
                AddGoalView()
            } label: {
                Text("Add Goal")
            }
            NavigationLink {
                AddTaskView()
            } label: {
                Text("Add Task")
            }
        }
        
        .fullScreenCover(isPresented: $viewModel.showRecommendedSong, content: {
//            if let song = recommendedSong {
            SpotifyRecommendationView(song: viewModel.recommendedSong)
//            }
        })
        
        .actionSheet(isPresented: $viewModel.showEventSpanOption) {
            ActionSheet(
                title: Text("Delete Event"),
                message: Text("Do you want to delete this event only or all future events?"),
                buttons: [
                    .default(Text("Delete This Event")) {
                        // Handle deleting this event
                        //                         addTaskViewModel.selectedEventSpan = .thisEvent
                        if let indexSetForDeletingTask = viewModel.indexSetForDeletingTask {
                            self.viewModel.deleteAtIndices(indexSetForDeletingTask, span: .thisEvent)
                        }
                    },
                    .default(Text("Delete All Future Events")) {
                        // Handle deleting all future events
                        //                         addTaskViewModel.selectedEventSpan = .futureEvents
                        if let indexSetForDeletingTask = viewModel.indexSetForDeletingTask {
                            self.viewModel.deleteAtIndices(indexSetForDeletingTask, span: .futureEvents)
                        }
                    },
                    .cancel()
                ]
            )
        }
        
    }


    }
    
    private var timeView: some View {
        CircleDividerView(day: $day,
                          isDaySetByMidnight: $isDaySetByMidnight,
                          wheelRotatesWithEOD: $wheelRotatesWithEOD, sleepTime: $sleepTime)
            .frame(width: 250, height: 250)
//            .padding(.vertical)
            .padding(.bottom, 40)

    }
    
    private var dayDefinitionSwitch: some View {
        Toggle(isOn: $isDaySetByMidnight) {
            Text("Day Defined By Midnight?")
        }
            .padding()
    }
    private var wheelRotationSwitch: some View {
        Toggle(isOn: $wheelRotatesWithEOD) {
            Text("Wheel rotates withe EOD?")
        }
            .padding()
    }
    
    private var sleepAdjuster: some View {
        VStack {
            Text("Sleep(start: \(Int(sleepTime.start)), end: \(Int(sleepTime.end)), duration: \(Int(sleepTime.duration)))")
            Button {
                sleepTime.start += 1
                sleepTime.end += 1
                
            } label: {
                Text("Up One")
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NavigationStack {
                Home()
            }
        }
    }
}
