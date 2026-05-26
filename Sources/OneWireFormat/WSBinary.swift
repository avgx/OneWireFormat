import Foundation
import OSLog

public enum WSBinary {
    /// Распарсенный бинарный кадр медиапотока.
    public struct Packet: Sendable {
        /// Тип полезной нагрузки в пакете.
        public enum PacketType: UInt8, Sendable {
            case video = 0
            case subtitles = 1
            case vmda = 2
            case mask = 3
        }
        
        public let streamId: UUID
        public let ts: Date
        public let type: PacketType
        public let payload: Data
        
        /// `true`, если кадр относится к субтитрам.
        public var isSubtitles: Bool {
            type == .subtitles
        }
        
        /// Маркер `поток остановлен` - специальное значение метки времени.
        public var isStopped: Bool {
            ts > .distantFuture
        }
    }
}
extension WSBinary {
    /// Packet format
    /// 201X-XX-XX `idLen(2)|idBytes(var)|tsBytes(8)|dataBytes(var)`
    /// 2018-03-08  `idLen(2)|idBytes(var)|tsBytes(8)|prerollByte(1)|dataBytes(var)`
    /// 2022-08-18  `signLen(1)|idLen(2)|idBytes(var)|tsBytes(8)|prerollByte(1)|dataBytes(var)`
    ///
    /// type(1) + idLen(1) + id(36) + ts(8) + jpegData
    /// т.е. на самом деле идёт или idLen(2) или signLen(1)|idLen(2)
    /// 000024
    /// 0024
    /// длинна id пока укладывается в 1 байт. и в вебе там баг на парсинге.
    public static func parse(data: Data) throws -> Packet {
        guard data.count > 3 else {
            throw URLError(.cannotDecodeContentData)
        }
        
        var reader = ByteReader(data)
        
        ///signLen detection (backward compatibility)
        let oldStyle: Bool = (data[0] == 0 && data[1] == 0x24)
        
        /// TYPE.
        /// в старых версиях до 2022-08-18 этого нет. Вычитывается 0. т.к. длина id всегда 0x24
        let rawType = try reader.readUInt8()
        guard let type = Packet.PacketType(rawValue: rawType) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        
        
        /// stream ID
        /// а вот на этом моенте 1 байт для type мы уже вычитали.
        /// в старом варианте там всегда 0 - соответствует видео а дальше 1 байт на длину id
        /// в новом - тип пакет. а дальше 2 байта длина id
        let idLen = !oldStyle ? Int(try reader.readUInt16BE()) : Int(try reader.readUInt8())
        if idLen != 0x24 {
            os_log("warning: idLen != 0x24")
        }
        let idData = try reader.readBytes(count: idLen)
        
        //TODO: на самом деле не факт что тут может быть только UUID. надо проверить на реальном бэкэнде.
        guard
            let idString = String(data: idData, encoding: .utf8),
            let streamId = UUID(uuidString: idString)
        else {
            throw URLError(.cannotDecodeContentData)
        }
        
        /// TIMESTAMP
        let tsOffset = reader.offset
        /// Вот это всё - проверка валидности даты и необязательно.
        /// Если неоткопировать через Data() то обращение по индексу работает неправильно для сабдата чанка полученного из `data[a..<b]`
        let tsBytes = Data(data[tsOffset..<(tsOffset + 8)])
        //00 00 03 90 17 45 45 f7
        //00 00 02 00 00 00 00 00   19690907T184735.552000
        //00 00 04 FF 00 00 00 00   20740127T132611.584000
        //первые 2 байта сейчас обычно 0x00 0x00
        //timestamp = ms от epoch 1900
        if !(tsBytes[0] == 0x00 && tsBytes[1] == 0x00) {
            // можно добавить лог при необходимости
            os_log("warning: tsBytes out of real \(tsBytes)")
            throw URLError(.cannotDecodeContentData)
        }
        
        /// а вот тут реальное вычитывание даты
        let rawTs = try reader.readUInt64BE()
        
        
        
        let epochOffset: UInt64 = 2_208_988_800_000
        let unixMillis = Int64(rawTs) - Int64(epochOffset)
        let ts = Date(timeIntervalSince1970: TimeInterval(unixMillis) / 1000.0)
        
        // skip preroll byte (если он есть) - отследить это никак. только настройкой вероятно
//        if reader.offset < data.count {
//            try? reader.skip(1)
//        }
        
        /// PAYLOAD
        let payload = Data(reader.remainingData())
        
        return Packet(
            streamId: streamId,
            ts: ts,
            type: type,
            payload: payload
        )
    }
}
