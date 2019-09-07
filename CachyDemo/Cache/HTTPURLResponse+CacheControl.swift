import Foundation

extension HTTPURLResponse {
    struct CacheControl {
        var mustRevalidate: Bool {
            return values.contains("must-revalidate")
        }

        var noCache: Bool {
            return values.contains("no-cache")
        }

        var noStore: Bool {
            return values.contains("no-store")
        }

        var noTransform: Bool {
            return values.contains("no-transform")
        }

        var `public`: Bool {
            return values.contains("public")
        }

        var `private`: Bool {
            return values.contains("private")
        }

        var proxyRevalidate: Bool {
            return values.contains("proxy-revalidate")
        }

        var maxAge: Int? {
            return value(for: "max-age").flatMap(Int.init)
        }

        var sMaxAge: Int? {
            return value(for: "s-maxage").flatMap(Int.init)
        }

        init(string: String) {
            values = string.replacingOccurrences(of: " ", with: "").split(separator: ",")
        }

        private let values: [Substring]
        private func value(for key: String) -> String? {
            return values.filter { $0.contains(key) }.first.flatMap { $0.split(separator: "=").last }.map(String.init)
        }
    }
}
