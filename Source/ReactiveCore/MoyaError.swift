import Foundation

public enum MoyaError: ErrorType {
    case ImageMapping(MoyaResponse)
    case JSONMapping(MoyaResponse)
    case StringMapping(MoyaResponse)
    case StatusCode(MoyaResponse)
    case Data(MoyaResponse)
    case Underlying(ErrorType)
}

@available(*, deprecated=5.0, message="RACSignal support has been deprecated")
public let MoyaErrorDomain = "Moya"

@available(*, deprecated=5.0, message="RACSignal support has been deprecated")
public enum MoyaErrorCode: Int {
    case ImageMapping = 0
    case JSONMapping
    case StringMapping
    case StatusCode
    case Data
}

@available(*, deprecated=5.0, message="RACSignal support has been deprecated")
internal extension MoyaError {
    
    // Used to convert MoyaError to NSError for RACSignal
    var nsError: NSError {
        switch self {
        case .ImageMapping(let response):
            return NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.ImageMapping.rawValue, userInfo: ["data" : response])
        case .JSONMapping(let response):
            return NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: ["data" : response])
        case .StringMapping(let response):
            return NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.StringMapping.rawValue, userInfo: ["data" : response])
        case .StatusCode(let response):
            return NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.StatusCode.rawValue, userInfo: ["data" : response])
        case .Data(let response):
            return NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.Data.rawValue, userInfo: ["data" : response])
        case .Underlying(let error):
            return error as NSError
        }
    }
}
