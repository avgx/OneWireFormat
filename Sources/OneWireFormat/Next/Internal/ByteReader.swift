import Foundation

enum ByteReaderError: Error {
    case outOfBounds
}

struct ByteReader {
    private let data: Data
    private(set) var offset: Int = 0

    init(_ data: Data) {
        self.data = data
    }

    mutating func readUInt8() throws -> UInt8 {
        try ensureAvailable(1)
        defer { offset += 1 }
        return data[offset]
    }

    mutating func readUInt16BE() throws -> UInt16 {
        try ensureAvailable(2)
        defer { offset += 2 }
        return (UInt16(data[offset]) << 8) | UInt16(data[offset + 1])
    }

    mutating func readUInt64BE() throws -> UInt64 {
        try ensureAvailable(8)
        defer { offset += 8 }

        var value: UInt64 = 0
        for i in 0..<8 {
            value <<= 8
            value |= UInt64(data[offset + i])
        }
        return value
    }

    mutating func readBytes(count: Int) throws -> Data {
        try ensureAvailable(count)
        defer { offset += count }
        return data.subdata(in: offset..<(offset + count))
    }

    mutating func skip(_ count: Int) throws {
        try ensureAvailable(count)
        offset += count
    }

    func remainingData() -> Data {
        data.suffix(from: offset)
    }

    private func ensureAvailable(_ count: Int) throws {
        guard offset + count <= data.count else {
            throw ByteReaderError.outOfBounds
        }
    }
}
