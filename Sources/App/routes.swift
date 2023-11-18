import Vapor

func routes(_ app: Application) throws {
    let originAccountDomain = loadOriginAccountDomain(app: app)
    
    app.get { req in
        let params: WebFingerRequest
        do {
            params = try req.query.decode(WebFingerRequest.self)
        } catch {
            throw Abort(.badRequest)
        }
        
        let accountHandle = extractAccountHandle(
            from: params.resource,
            originAccountDomain: originAccountDomain
        )
        
        guard
            let redirection = redirections[accountHandle]
        else {
            throw Abort(.notFound)
        }
        let newURL = generateWebFingerRequestURL(
            newHost: redirection.domain,
            newUser: redirection.user,
            originalURL: req.url,
            originalResource: params.resource
        )
        return req.redirect(to: newURL)
    }
}
