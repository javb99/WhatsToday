//
//  EventStorage.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/9/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public extension URL {
    /// The documentDirectory in the userDomainMask.
    public static var appDocumentsURL: URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find the documents directory.")
        }
        return url
    }
}

/// A class to manage the reading and writing of events to disk.
public class EventStorage {
    
    /// The singleton instance. This is the only instance that can exist because the init is private.
    public static let shared = EventStorage()
    
    /// The URL to store the events at.
    internal static let storageURL = URL.appDocumentsURL.appendingPathComponent("EventStorage_Events.json")
    
    // We don't want anyone changing events without using one of the methods defined below. This gives us the option of saving every time an Event is added or deleted.
    public private(set) var events: [Event]
    
    // Private init to prevent more than one instance to be initialized.
    private init() {
        do {
            let eventsData = try Data(contentsOf: EventStorage.storageURL)
            events = try JSONDecoder().decode(Array<Event>.self, from: eventsData)
        } catch {
            print("Failed to read events from file. Creating a fresh array for events. If allowed to save, this will overwrite any corrupted event storage.")
            events = []
        }
    }
    
    public func save() {
        print("Saving events to \(EventStorage.storageURL.absoluteString)")
        do {
            let eventsData = try JSONEncoder().encode(events)
            try eventsData.write(to: EventStorage.storageURL)
        } catch {
            print("Failed to save events.")
        }
    }
    
    deinit {
        save()
    }
    
    public func add(_ event: Event) {
        events.append(event)
    }
    
    public func add<S: Sequence>(contentsOf sequence: S) -> Void where S.Element == Event {
        events.append(contentsOf: sequence)
    }
    
    public func remove(_ event: Event) {
        /// Find the given event.
        guard let index = events.index(of: event) else {
            preconditionFailure("Event passed in to remove(_:) doesn't exist in events.")
        }
        remove(at: index)
    }
    
    public func remove(at index: Int) {
        events.remove(at: index)
    }
}
