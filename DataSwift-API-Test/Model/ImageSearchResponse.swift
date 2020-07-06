import Foundation

struct ImageSearchResponse: Codable {
    let collection: Collection?
    
    struct Collection: Codable {
        let items: [Item]?
    }
    
    struct Item: Codable {
        let data: [Datum]?
        let links: [Link]?
    }
    
    struct Datum: Codable {
        let description: String?
        let keywords: [String]?
        let title: String?
    }
    
    struct Link: Codable {
        let href: String?
        let render: String?
    }
}
