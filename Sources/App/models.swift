//
//  File.swift
//  
//
//  Created by Jhonatan A. on 17/11/23.
//

import Vapor

struct WebFingerRequest: Content {
    var resource: String
}

struct WebFingerRedirectionDestination: Decodable {
    let user: String
    let domain: String
}
