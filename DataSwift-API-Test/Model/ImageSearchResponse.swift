import Foundation

struct ImageSearchResponse: Codable {
    let collection: Collection?
    
    struct Collection: Codable {
        let href: String?
        let items: [Item]?
        let links: [CollectionLink]?
        let metadata: Metadata?
        let version: String?
    }
    
    struct Item: Codable {
        let data: [Datum]?
        let href: String?
        let links: [DataLink]?
    }
    
    struct Datum: Codable {
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
    
    struct DataLink: Codable {
        let href: String?
        let rel: String?
        let render: String?
    }
    
    struct CollectionLink: Codable {
        let href: String?
        let prompt: String?
        let rel: String?
    }
    
    struct Metadata: Codable {
        let totalHits: Int?
        
        private enum CodingKeys: String, CodingKey {
            case totalHits = "total_hits"
        }
    }
}
