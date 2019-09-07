import Foundation

extension HTTPURLResponse {
    struct Header {
        private enum Const {
            static let calendar = Calendar(identifier: .gregorian)
            static let formatter: DateFormatter = {
                let df = DateFormatter()
                df.locale = Locale(identifier: "en_US_POSIX")
                df.dateFormat = "E, dd M yyyy HH:mm:ss Z"
                return df
            }()
        }

        struct FieldKey: Equatable {
            static func== (lhs: FieldKey, rhs: FieldKey) -> Bool {
                return lhs.rawValue == rhs.rawValue
            }

            let rawValue: String

            init(_ key: String) {
                rawValue = key
            }

            static let cacheControl = FieldKey("Cache-Control")
            static let date = FieldKey("Date")
            static let lastModified = FieldKey("Last-Modified")
            static let expires = FieldKey("Expires")
            static let etag = FieldKey("Etag")
        }

        let fields: [AnyHashable: Any]

        func value(for key: FieldKey) -> String? {
            return fields[key.rawValue] as? String
        }

        var cacheControl: CacheControl? {
            return value(for: .cacheControl).flatMap(CacheControl.init)
        }

        var date: Date? {
            return value(for: .date).flatMap(Const.formatter.date)
        }

        var lastModified: Date? {
            return value(for: .lastModified).flatMap(Const.formatter.date)
        }

        var expires: Date? {
            if let expires = value(for: .expires).flatMap(Const.formatter.date) {
                return expires
            }
            let components = DateComponents(second: cacheControl?.maxAge)
            return date.flatMap { Const.calendar.date(byAdding: components, to: $0) }
        }

        var etag: String? {
            return value(for: .etag)
        }
    }

    var header: Header {
        return Header(fields: allHeaderFields)
    }
}
