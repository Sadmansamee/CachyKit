import Foundation

class Cache: URLCache {
    /// set greater than 0 if needs to return cache forcibly, then the cache will be returned until past it.
    /// if it is set less than 0, it is ignored.
    /// also, it checks before the validity of response header.
    public var minimumAge = 0

    private var excludable: CacheExcludable?

    init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?, excludable: CacheExcludable? = nil, minimumAge: Int = 0) {
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
        self.excludable = excludable
        self.minimumAge = minimumAge
    }

    func dateIsPast(_ target: Date?) -> Bool {
        guard let target = target else {
            return false
        }

        let current = Date()
        if minimumAge == 0 {
            return current > target
        } else if minimumAge >= 1 {
            let components = DateComponents(second: -minimumAge)
            let calendar = Calendar(identifier: .gregorian)
            if let date = calendar.date(byAdding: components, to: current) {
                return date > target
            }
        }

        return false
    }

    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let cache = super.cachedResponse(for: request)

        guard let httpResponse = cache?.httpResponse else {
            return nil
        }

        guard dateIsPast(httpResponse.header.expires) == false else {
            return nil
        }

        guard excludable?.canRespondCache(with: httpResponse) != false else {
            return nil
        }

        return cache
    }

    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        guard let httpResponse = cachedResponse.httpResponse else {
            return
        }

        guard dateIsPast(httpResponse.header.expires) == false else {
            return
        }

        if excludable?.canStoreCache(with: httpResponse) != false {
            super.storeCachedResponse(cachedResponse, for: request)
        }
    }
}

private extension CachedURLResponse {
    var httpResponse: HTTPURLResponse? {
        return response as? HTTPURLResponse
    }
}
