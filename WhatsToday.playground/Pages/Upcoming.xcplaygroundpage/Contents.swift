//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import WhatsTodayPlaygroundAccessible

let populator = EventPopulator()
let events = populator.createRandomEvents(count: 10)
for event in events {
    EventStorage.shared.add(event)
}

let viewController = UpcomingViewController()
viewController.refreshUpcomingEvents()
PlaygroundPage.current.liveView = viewController
viewController.view

//: [Next](@next)
