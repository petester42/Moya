import Argo
import Curry

struct Repo {
    let name: String
}

extension Repo: Decodable {
    
    static func decode(json: JSON) -> Decoded<Repo> {
        return curry(Repo.init)
            <^> json <| "name"
    }
}
