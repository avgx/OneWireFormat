import Foundation

extension Timestamp {
    /// Wire timestamp: `yyyyMMdd'T'HHmmss[.fraction]`.
    ///
    /// Fractional seconds may be 3 (ms), 6 (µs), or 9 (ns) digits after the dot.
    public final class Formatter: DateFormatter, @unchecked Sendable {
        let withoutSeconds: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "yyyyMMdd'T'HHmmss"
            return formatter
        }()

        private let microsecondsPrefix = "."

        func setup() {
            calendar = Calendar(identifier: .iso8601)
            locale = Locale(identifier: "en_US_POSIX")
            timeZone = TimeZone(identifier: "UTC")
            dateFormat = "yyyyMMdd'T'HHmmss"
        }

        override init() {
            super.init()
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        override public func date(from string: String) -> Date? {
            guard let microsecondsPrefixRange = string.range(of: microsecondsPrefix) else {
                return withoutSeconds.date(from: string)
            }
            let microsecondsString = String(string.suffix(from: microsecondsPrefixRange.upperBound))
            guard let microsecondsCount = Double(microsecondsString) else {
                return withoutSeconds.date(from: string)
            }

            let dateStringExcludingMicroseconds = String(string.prefix(upTo: microsecondsPrefixRange.lowerBound))

            guard let date = super.date(from: dateStringExcludingMicroseconds) else {
                return nil
            }

            let digits = microsecondsString.count
            switch digits {
            case 3:
                return date + microsecondsCount / 1_000
            case 6:
                return date + microsecondsCount / 1_000_000
            case 9:
                return date + microsecondsCount / 1_000_000_000
            default:
                return date
            }
        }

        override public func string(from date: Date) -> String {
            dateFormat = "yyyyMMdd'T'HHmmss"
            let components = calendar.dateComponents(Set([Calendar.Component.nanosecond]), from: date)

            let nanosecondsInMicrosecond = Double(1_000)
            let microseconds = lrint(Double(components.nanosecond!) / nanosecondsInMicrosecond)

            let updatedDate = calendar.date(byAdding: .nanosecond, value: -(components.nanosecond!), to: date)!
            let dateTimeString = super.string(from: updatedDate)

            return String(format: "%@.%06ld", dateTimeString, microseconds)
        }
    }
}
