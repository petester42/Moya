import Foundation

public enum MoyaError: ErrorType {
    case ImageMapping(MoyaResponse)
    case JSONMapping(MoyaResponse)
    case StringMapping(MoyaResponse)
    case StatusCode(MoyaResponse)
    case Data(MoyaResponse)
    case Underlying(ErrorType)
}

extension MoyaError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ImageMapping(let response):
            return "Image mapping failed (response: \(response)"
        case .JSONMapping(let response):
            return "JSON mapping failed (response: \(response)"
        case .StringMapping(let response):
            return "String mapping failed (response: \(response)"
        case .StatusCode(let response):
            return "Status code mapping failed (response: \(response)"
        case .Data(let response):
            return "Data mapping failed (response: \(response)"
        case .Underlying(let error):
            return (error as NSError).description
        }
    }
}

@available(*, deprecated, message="This will be removed when ReactiveCocoa 4 becomes final. Please visit https://github.com/Moya/Moya/issues/298 for more information.")
public let MoyaErrorDomain = "Moya"

@available(*, deprecated, message="This will be removed when ReactiveCocoa 4 becomes final. Please visit https://github.com/Moya/Moya/issues/298 for more information.")
public enum MoyaErrorCode: Int {
    case ImageMapping = 0
    case JSONMapping
    case StringMapping
    case StatusCode
    case Data
}

@available(*, deprecated, message="This will be removed when ReactiveCocoa 4 becomes final. Please visit https://github.com/Moya/Moya/issues/298 for more information.")
public extension MoyaError {
    
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
