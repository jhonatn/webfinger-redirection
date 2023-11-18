//
//  File.swift
//  
//
//  Created by Jhonatan A. on 17/11/23.
//

import Vapor

func extractAccountHandle(from acct: String, originAccountDomain: String) -> String {
    var accountHandle = acct
    if
        let schemeRange = accountHandle.range(of: "acct:"),
        schemeRange.lowerBound == accountHandle.startIndex
    {
        accountHandle.removeSubrange(schemeRange)
    }
    
    if let domainRange = accountHandle.range(of: "@\(originAccountDomain)") {
        let everythingElseRange = domainRange.lowerBound ..< accountHandle.endIndex
        accountHandle.removeSubrange(everythingElseRange)
    }
    return accountHandle
}

func loadOriginAccountDomain(app: Application) -> String {
    let forcedHost: String? = Environment.get("ORIGIN_ACCOUNT_DOMAIN")
    let originAccountDomain: String
    if !app.environment.isRelease, let forcedHost {
        originAccountDomain = forcedHost
    } else {
        originAccountDomain = app.http.server.configuration.hostname
    }
    return originAccountDomain
}

func generateWebFingerRequestURL(
    newHost: String,
    newUser: String,
    originalURL: URI,
    originalResource: String
) -> String {
    var newUrl = originalURL
    newUrl.scheme = "https"
    newUrl.host = newHost
    newUrl.path = "/.well-known/webfinger"
    newUrl.query = newUrl.query?.replacingOccurrences(of: originalResource, with: "acct:\(newUser)@\(newHost)")
    return newUrl.string
}
