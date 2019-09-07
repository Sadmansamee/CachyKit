import Foundation

protocol CacheExcludable {
    /// it can check response header. return false if needs to refuse to cache.
    func canRespondCache(with httpResponse: HTTPURLResponse) -> Bool
    func canStoreCache(with httpResponse: HTTPURLResponse) -> Bool
}

// struct Excluder: CacheExcludable {
//    func canRespondCache(with httpResponse: HTTPURLResponse) -> Bool {
//        return httpResponse.header.cacheControl?.noCache != false
//    }
//
//    func canStoreCache(with httpResponse: HTTPURLResponse) -> Bool {
//        return httpResponse.header.cacheControl?.noStore != false
//    }
// }
