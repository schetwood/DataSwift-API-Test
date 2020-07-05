import Foundation

protocol SearchResultsPersistenceManager {
    func updateResponse(_ response: ImageSearchResponse, forKey: String)
    func getStoredResult(forKey: String) -> ImageSearchResponse?
}

class UserDefaultsPersistenceManager: SearchResultsPersistenceManager {
    static let objectKey = "persistent-results"
    
    struct KeyedResponse: Codable {
        let key: String
        let response: ImageSearchResponse
    }
    
    private var keyedResponses: [KeyedResponse]
    private let maxResponseCount: Int
    
    init(maxResponseCount: Int = 20) {
        self.maxResponseCount = maxResponseCount
        let object = UserDefaults.standard.object(forKey: UserDefaultsPersistenceManager.objectKey)
        guard let data = object as? Data else {
            keyedResponses = []
            return
        }
        
        let decoded: [KeyedResponse]?
        do {
            decoded = try JSONDecoder().decode([KeyedResponse].self, from: data)
        } catch let error {
            print("Error retrieving from User Defaults: \(error.localizedDescription)")
            decoded = nil
        }
        
        keyedResponses = decoded ?? []
    }
    
    func updateResponse(_ response: ImageSearchResponse, forKey key: String) {
        keyedResponses.removeAll { $0.key == key }
        keyedResponses.append(KeyedResponse(key: key, response: response))
        if keyedResponses.count > maxResponseCount {
            let numberToDrop = keyedResponses.count - maxResponseCount
            keyedResponses.removeFirst(numberToDrop)
        }
        
        DispatchQueue.global(qos: .background).async {
            do {
                let jsonData = try JSONEncoder().encode(self.keyedResponses)
                UserDefaults.standard.set(jsonData as NSData, forKey: UserDefaultsPersistenceManager.objectKey)
            } catch let error {
                print("Error saving to User Defaults: \(error.localizedDescription)")
            }
        }
    }
    
    func getStoredResult(forKey key: String) -> ImageSearchResponse? {
        return keyedResponses.first(where: { $0.key == key })?.response
    }
}
