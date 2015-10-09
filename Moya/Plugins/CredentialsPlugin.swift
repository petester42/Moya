import Foundation

/// Provides each request with optional NSURLCredentials.
public class CredentialsPlugin: Plugin {

    public typealias CredentialClosure = MoyaTarget -> NSURLCredential?
    let credentialsClosure: CredentialClosure

    public init(credentialsClosure: CredentialClosure) {
        self.credentialsClosure = credentialsClosure
    }

    // MARK: Plugin
    
    public func willSendRequest<Target: MoyaTarget>(request: MoyaRequest, provider: MoyaProvider<Target>, target: Target) {
        if let credentials = credentialsClosure(target) {
            request.authenticate(usingCredential: credentials)
        }
    }
    
    public func didReceiveResponse<Target: MoyaTarget>(data: NSData?, statusCode: Int?, response: NSURLResponse?, error: ErrorType?, provider: MoyaProvider<Target>, target: Target) {
        
    }
}