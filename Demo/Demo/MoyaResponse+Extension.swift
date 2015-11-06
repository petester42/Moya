import Moya
import Argo
import ObjectMapper

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

public extension MoyaResponse {

    func mapObjectMapper<U: Mappable>() throws -> [U] {

        let response = try self.mapJSON()
        guard let decoded: [U] = Mapper<U>().mapArray(response) else {
            throw NSError(domain: MoyaErrorDomain, code: MoyaErrorCode.JSONMapping.rawValue, userInfo: nil)
        }
        
        return decoded
    }
}

public extension MoyaProvider {
    
    func request<U: Mappable>(target: Target, completion: (response: [U]?, error: ErrorType?) -> ()) -> Cancellable {
        return request(target) { response, error in
            do {
                completion(response: try response?.mapObjectMapper(), error: error)
            } catch {
                completion(response: nil, error: error)
            }
        }
    }
}