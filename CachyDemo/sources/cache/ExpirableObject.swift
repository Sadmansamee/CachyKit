import UIKit

public class ExpirableObject: NSObject, NSCoding {
    // MARK: - Singleton properties

    // MARK: - Static properties

    // MARK: - Public properties

    /// Public property to store the value of the object
    public let value: AnyObject

    /// Public property to store the key of the object
    public let key: String

    /// Public property to store the expiration date of the object
    public let expirationDate: Date

    /// Public property to indicate if the object is expired
    open var isExpired: Bool {
        return Date().timeIntervalSinceNow > expirationDate.timeIntervalSinceNow
    }

    /// Public property to indicate if an object is updated
    open var isUpdated = false

    // MARK: - Public methods

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
        aCoder.encode(key, forKey: "key")
        aCoder.encode(expirationDate, forKey: "expirationDate")
    }

    // MARK: - Initialize/Livecycle methods

    /// Constructor to initilise a cache object
    ///
    /// - Parameters:
    ///   - value: The value of the cache object
    ///   - key: The key of the cache object
    ///   - expirationDate: The expiration date of the cache object (By default it sets the global cache expiraiton date)
    public init(value: AnyObject, key: String, expirationDate: Date? = nil) {
        self.value = value
        self.key = key
        self.expirationDate = expirationDate ?? ExpirableCache.shared.expiration.date

        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let value = aDecoder.decodeObject(forKey: "value"),
            let key = aDecoder.decodeObject(forKey: "key") as? String,
            let expirationDate = aDecoder.decodeObject(forKey: "expirationDate") as? Date else {
            return nil
        }

        self.value = value as AnyObject
        self.key = key
        self.expirationDate = expirationDate

        super.init()
    }

    // MARK: - Override methods

    // MARK: - Private properties

    // MARK: - Private methods
}
