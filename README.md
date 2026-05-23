# OneWireFormat

A Swift package providing wire-format definitions and decoding.

## Timestamp wire formats

Server timestamps use compact UTC strings with optional fractional seconds:

| Example | Notes |
|---------|-------|
| `20260403T123542.757638` | 6-digit microseconds (WebSocket events) |
| `20260403T123542` | Without fractional part |

### API

```swift
import OneWireFormat

let utc = Timestamp.utc
let date = utc.date(from: "20260403T123542.757638")
let wire = utc.string(from: date!)

let local = Timestamp.local // TimeZone.current
```

`Timestamp.Formatter` parses 3 (ms), 6 (µs), or 9 (ns) fractional digits.

## WebSocket binary payloads

`WSBinary` decodes binary media frames from the WebSocket stream.

| Field | Notes |
|-------|-------|
| `type` | `video`, `subtitles`, `vmda`, or `mask` |
| `streamId` | UUID of the media source |
| `ts` | Unix timestamp (ms since 1970, converted from wire epoch 1900) |
| `payload` | Remaining bytes (e.g. JPEG, fMP4 init segment) |

Wire layout (new format): `type(1) | idLen(2) | id(36) | ts(8) | payload`.

```swift
let frame = try WSBinary.parse(data: binaryData)
print(frame.streamId, frame.ts, frame.type, frame.payload.count)
```

## WebSocket string payloads

`WSString` decodes JSON event packs shaped as `{ "objects": [ {...}, ... ] }`.

| Field | Notes |
|-------|-------|
| `type` | Event kind (required), e.g. `cameraarmstateevent`, `detector_event` |
| `id` | Event UUID |
| `timestamp` | Wire UTC string; use `Timestamp.utc` to parse |
| `event_type` | Detector sub-type, e.g. `faceAppeared`, `MotionDetected` |
| `source` | Device endpoint path |
| `raw` | Full event JSON for typed decoding of extra fields |

```swift
let events = try WSString.decodeEventsPack(from: jsonData)
for event in events {
    let date = Timestamp.utc.date(from: event.timestamp ?? "")
}
```
