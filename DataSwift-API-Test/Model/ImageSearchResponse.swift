import Foundation

struct ImageSearchResponse: Decodable {
    let collection: Collection?
    
    struct Collection: Decodable {
        let href: String?
        let items: [Item]?
        let links: [CollectionLink]?
        let metadata: Metadata?
        let version: String?
    }
    
    struct Item: Decodable {
        let data: [Datum]?
        let href: String?
        let links: [DataLink]?
    }
    
    struct Datum: Decodable {
        let center: String?
        let dateCreated: String?
        let description: String?
        let keywords: [String]?
        let mediaType: String?
        let nasaID: String?
        let title: String?
        
        private enum CodingKeys: String, CodingKey {
            case center
            case dateCreated = "date_created"
            case description
            case keywords
            case mediaType = "media_type"
            case nasaID = "nasa_id"
            case title
        }
    }
    
    struct DataLink: Decodable {
        let href: String?
        let rel: String?
        let render: String?
    }
    
    struct CollectionLink: Decodable {
        let href: String?
        let prompt: String?
        let rel: String?
    }
    
    struct Metadata: Decodable {
        let totalHits: Int?
        
        private enum CodingKeys: String, CodingKey {
            case totalHits = "total_hits"
        }
    }
}
