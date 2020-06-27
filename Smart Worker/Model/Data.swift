//
//  UserData.swift
//  Smart Worker
//
//  Created by Hamza Imran on 19/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import Foundation


struct NotificationsData {
    let message: String
}

struct requests {
    let date: String
    let time: String
    let duration: String
    let requestKey: String
    let customerId: String
    let customerLocation: Location
}

struct FutureRequests {
    let date: String
    let time: String
    let customerLocation: FutureLocation
    let requestKey: String
    let customerId: String
}


struct PresentRequests {
    let date: String
    let time: String
    let requestKey: String
    let customerId: String
    let handymanId: String
}


struct PastAppointments {
    let date: String
    let time: String
    let duration: String
    let appointmentKey: String
    let bill: String
    let rating: Double
    let customerId: String
    let handymanId: String
}


struct Location {
    let latitude: String
    let longitude: String
}


struct FutureLocation {
    let latitude: String
    let longitude: String
}

struct CustomerData {
    let firstName: String
    let lastName: String
    let phone: String
    let imageUrl: String
}


struct PresentCustomerData {
    let firstName: String
    let lastName: String
    let imageUrl: String
}

struct FutureCustomerData {
    let firstName: String
    let lastName: String
    let phone: String
    let imageUrl: String
}
