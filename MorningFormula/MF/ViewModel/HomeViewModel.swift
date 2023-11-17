//
//  HomeViewModel.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/9/23.
//

import SwiftUI
import EventKit

class HomeViewModel: ObservableObject {
    static let instance = HomeViewModel(eventManager: EventManager.instance, firebaseManager: FirebaseManager.instance)
    
    var eventManager: EventKitService
    var firebaseManager: FirebaseManager
    
    @Published var addActionIsVisible = false
    @Published var showEventSpanOption = false
    @Published var indexSetForDeletingTask: IndexSet?
    
    @Published var showRecommendedSong = false
    @Published var recommendedSong = SpotifyItem()
    
     var tasks: [MFTask] = [] {
        didSet {
            sortedTasks = tasks.sortedByTime()
        }
    }
    @Published var sortedTasks: [MFTask] = []
    
    var ekEvents: [EKEvent] = [] {
        didSet {
            
            self.tasks = []
            self.setTasksFromEvents { task in
                self.tasks.append(task)
            }
        }
    }
    
    init(eventManager: EventKitService, firebaseManager: FirebaseManager) {
        self.eventManager = eventManager
        self.firebaseManager = firebaseManager
    }
    
    func setTasksFromEvents(withCompletion completion: @escaping(MFTask) -> Void) {
        for event in ekEvents {
            firebaseManager.getTask(event.eventIdentifier) { task, error in
                if let task = task {
                    completion(task)
                }
            }
        }
    }
    
    //MARK: - Delete
    func deleteAtIndices(_ index: IndexSet, span: EKSpan) {
        for i in index.makeIterator() {
            removeFromEKEvents(i, span)
        }
    }
    
    private func removeFromEKEvents(_ index: IndexSet.Element, _ span: EKSpan) {
        print(ekEvents.count)
        if ekEvents.indices.contains(index) {
            let sortedEKEvents = ekEvents.sortedByTime()
        let event = sortedEKEvents[index]
            eventManager.deleteEvent(event, span: span) { success in
                if success {
                    self.firebaseManager.deleteTask(event.eventIdentifier) { success, error in
                        if success {
                            self.eventManager.fetchEvents { events in
                                DispatchQueue.main.async {
                                    print("eventCount: \(events.count)")
                                    self.ekEvents = events
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func toolbarAddTapped() {
        self.addActionIsVisible = true
    }
}
