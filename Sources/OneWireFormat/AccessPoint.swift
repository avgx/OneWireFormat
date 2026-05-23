import Foundation

/// Wire `access_point` path (Native BL proto).
public typealias AccessPoint = String

private let hostsPrefix = "hosts/"

extension AccessPoint {
    public static let invalidAccessPoint = "invalid/invalid/invalid"

    /// Path without the `hosts/` prefix (3 segments).
    public var nohosts: String {
        guard !self.isEmpty else { return self }
        precondition([3, 4, 5].contains(self.components(separatedBy: "/").count), "AccessPoint format validation")
        return self.starts(with: hostsPrefix) ? String(self.dropFirst(hostsPrefix.count)) : self
    }

    /// Path with the `hosts/` prefix (4 segments).
    public var hosts: String {
        guard !self.isEmpty else { return self }
        precondition([3, 4, 5].contains(self.components(separatedBy: "/").count), "AccessPoint format validation")
        return self.starts(with: hostsPrefix) ? self : "\(hostsPrefix)\(self)"
    }

    /// Device path without the endpoint segment.
    public var hostsDevice: String {
        self.hosts.components(separatedBy: "/").dropLast().joined(separator: "/")
    }

    /// Device number from `DeviceIpint.N`.
    public var deviceID: String {
        guard !self.isEmpty else { return self }
        return self.nohosts.components(separatedBy: "/")[1].components(separatedBy: ".")[1]
    }
}
