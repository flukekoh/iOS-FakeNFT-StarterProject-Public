import Foundation

enum SortType: String {
    case byName
    case byNFT
}

final class SortManager {
    private let userDefaults = UserDefaults.standard
    
    func getSortValue() -> String {
        guard let sort = userDefaults.string(forKey: "Sort") else { return "" }
        return sort
    }
    
    func setSortValue(value: String) {
        userDefaults.set(value, forKey: "Sort")
    }
}
