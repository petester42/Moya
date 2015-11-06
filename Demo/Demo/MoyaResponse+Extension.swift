import Moya
import Argo

public extension MoyaResponse {
    
    func mapEntity<U: Decodable where U == U.DecodedType>() throws -> U {
        
        let response = try self.mapJSON()
        let decoded: Decoded<U> = decode(response)
        
        switch decoded {
        case .Success(let success):
            return success
        case let .Failure(.MissingKey(key)):
            throw NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: ["data": response, "missing": key])
        case let .Failure(.TypeMismatch(expected, actual)):
            throw NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: ["data": response, "expected": expected, "actual": actual])
        case let .Failure(.Custom(error)):
            throw NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: ["data": response, "custom": error])
        }
    }
    
    func mapEntity<U: Decodable where U == U.DecodedType>() throws -> [U] {
        
        let response = try self.mapJSON()
        let decoded: Decoded<[U]> = decode(response)
        
        switch decoded {
        case .Success(let success):
            return success
        case let .Failure(.MissingKey(key)):
            throw NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: ["data": response, "missing": key])
        case let .Failure(.TypeMismatch(expected, actual)):
            throw NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: ["data": response, "expected": expected, "actual": actual])
        case let .Failure(.Custom(error)):
            throw NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: ["data": response, "custom": error])
        }
    }
}

public extension MoyaProvider {
    
    func request<U: Decodable where U == U.DecodedType>(target: Target, completion: (response: [U]?, error: ErrorType?) -> ()) -> Cancellable {
        return request(target) { response, error in
            do {
                completion(response: try response?.mapEntity(), error: error)
            } catch {
                completion(response: nil, error: error)
            }
        }
    }
}