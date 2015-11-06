import Argo
import Curry
import ObjectMapper

struct Repo {
    var name: String
}

//extension Repo: Decodable {
//    
//    static func decode(json: JSON) -> Decoded<Repo> {
//        return curry(Repo.init)
//            <^> json <| "name"
//    }
//}

extension Repo: Mappable {
    
    init?(_ map: Map) {
        name = ""
        name <- map["name"]
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
    }
}