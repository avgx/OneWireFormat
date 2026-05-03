import Testing
import Foundation
@testable import OneWireFormat

/// Примеры для этого теста получены через
/// bash-3.2$ websocat 'ws://try.axxonsoft.com/events'
struct NextStringProtocolDecodeTests {
    @Test(arguments: [
        (
            """
            {     "objects" :      [         {             "id" : "661e0226-fc00-4b29-bcbe-57ae32dde463",             "source" : "hosts/Demoserver/DeviceIpint.1/SourceEndpoint.video:0:0",         "state" : "CS_Arm",             "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         },         {             "id" : "cf8032ce-948e-4456-9d83-df8d7eec5c7a",             "source" : "hosts/Demoserver/DeviceIpint.2/SourceEndpoint.video:0:0",             "state" : "CS_Disarm",             "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         },         {             "id" : "383a1bde-77c4-405c-a5cc-1135d6398056",             "source" : "hosts/Demoserver/DeviceIpint.3/SourceEndpoint.video:0:0",             "state" : "CS_Disarm",             "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         },         {             "id" : "897cf69e-694f-4df0-8c99-224d94772488",             "source" : "hosts/Demoserver/DeviceIpint.4/SourceEndpoint.video:0:0",             "state" : "CS_Arm",             "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         },         {             "id" : "ab05056b-5001-44d1-9c06-25710173fd83",             "source" : "hosts/Demoserver/DeviceIpint.5/SourceEndpoint.video:0:0",             "state" : "CS_Disarm",             "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         },         {             "id" : "83bb11eb-aee1-4c4a-8316-09e92b65320b",             "source" : "hosts/Demoserver/DeviceIpint.6/SourceEndpoint.video:0:0",             "state" : "CS_Arm",             "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         }, {             "id" : "24ec2cf3-5a30-4817-b197-9fffe105abd2",             "source" : "hosts/Demoserver/DeviceIpint.7/SourceEndpoint.video:0:0",             "state" : "CS_Disarm",         "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         }     ] }
            """,
            ["cameraarmstateevent"],
            7
        ),
        (
            """
            {     "objects" :      [         {             "event_type" : "faceAppeared",             "faceInfo" :              {                 "age" : 0,             "gender" : 0             },             "id" : "fc908c61-f4d7-40a3-a7ed-77e05c489c5d",             "rectangles" :              [                 {         "bottom" : 0.37888888888888889,                     "index" : 10391854,                     "left" : 0.31937500000000002,                     "right" : 0.39156250000000004,                     "top" : 0.18962962962962965                 }             ],             "source" : "hosts/Demoserver/DeviceIpint.1/SourceEndpoint.video:0:0",             "state" : 0,             "timestamp" : "20260403T125856.734000",             "type" : "detector_event"         }     ] }    
            """,
            ["detector_event"],
            1
        ),
        (
            """
            {     "objects" :      [         {             "event_type" : "plateRecognized",             "id" : "26f779bd-eca3-444d-931b-bc67b3a6029e",             "plate_full" : "LO6259L",             "rectangles" :              [                 {                     "bottom" : 0.62152777777777779,                     "index" : 0,                     "left" : 0.63020833333333337,                     "right" : 0.81380208333333337,                     "top" : 0.55208333333333337 }             ],             "source" : "hosts/Demoserver/DeviceIpint.3/SourceEndpoint.video:0:0",             "state" : 0,             "timestamp" : "20260403T125856.678000",             "type" : "detector_event"         }     ] }
            """,
            ["detector_event"],
            1
        ),
        (
            """
            {     "objects" :      [         {             "event_type" : "MotionDetected",             "id" : "0a86bab7-e0b9-449b-85d0-38b385bb2c8d",             "source" : "hosts/Demoserver/DeviceIpint.4/SourceEndpoint.video:0:0",             "state" : 1,             "timestamp" : "20260403T125858.516000",             "type" : "detector_event"         }     ] }
            """,
            ["detector_event"],
            1
        ),
        (
            """
            {     "objects" :      [         {             "event_type" : "oneLine",             "id" : "c0108b3f-6c3f-4c37-80e0-75e8b71333fa",             "rectangles" :          [                 {                     "bottom" : 0.6707762824164496,                     "index" : 30388030,                     "left" : 0.40068640708923337,                     "right" : 0.60531144142150872,                     "top" : 0.58344319661458333                 }             ], "source" : "hosts/Demoserver/DeviceIpint.5/SourceEndpoint.video:0:0",             "state" : 1,             "timestamp" : "20260403T125900.234000",             "type" : "detector_event"         }     ] }
            """,
            ["detector_event"],
            1
        ),
        (
            """
            {     "objects" :      [
             {
               "type" : "ObjectActivatedEvent",
               "objectIdExt" : {
                 "accessPoint" : "hosts/DESKTOP-21M7L0R/DeviceIpint.1/SourceEndpoint.video:0:0",
                 "group" : "",
                 "friendlyName" : "hosts/DESKTOP-21M7L0R/DeviceIpint.1/SourceEndpoint.video:0:0"
               },
               "timestamp" : "20260330T081832.379813",
               "isActivated" : true,
               "nodeInfo" : {
                 "name" : "DESKTOP-21M7L0R",
                 "friendlyName" : "DESKTOP-21M7L0R"
               },
               "guid" : "4466cda7-6623-4273-bf40-ab097c9cc5ea"
             },
             {
               "isActivated" : true,
               "timestamp" : "20260330T081831.618224",
               "nodeInfo" : {
                 "name" : "DESKTOP-21M7L0R",
                 "friendlyName" : "DESKTOP-21M7L0R"
               },
               "guid" : "",
               "type" : "ObjectActivatedEvent",
               "objectIdExt" : {
                 "friendlyName" : "hosts/DESKTOP-21M7L0R/PortDiscovery.0",
                 "group" : "",
                 "accessPoint" : "hosts/DESKTOP-21M7L0R/PortDiscovery.0"
               }
             },
             {
               "nodeInfo" : {
                 "friendlyName" : "DESKTOP-21M7L0R",
                 "name" : "DESKTOP-21M7L0R"
               },
               "type" : "ObjectActivatedEvent",
               "timestamp" : "20260330T081832.070847",
               "guid" : "",
               "isActivated" : true,
               "objectIdExt" : {
                 "accessPoint" : "hosts/DESKTOP-21M7L0R/VideoDecoder.1",
                 "group" : "",
                 "friendlyName" : "hosts/DESKTOP-21M7L0R/VideoDecoder.1"
               }
             },
             {
               "type" : "ObjectActivatedEvent",
               "objectIdExt" : {
                 "group" : "",
                 "friendlyName" : "hosts/DESKTOP-21M7L0R",
                 "accessPoint" : "hosts/DESKTOP-21M7L0R"
               },
               "timestamp" : "",
               "isActivated" : true,
               "nodeInfo" : {
                 "name" : "DESKTOP-21M7L0R",
                 "friendlyName" : "DESKTOP-21M7L0R"
               },
               "guid" : ""
             }
            ] }
            """,
            ["ObjectActivatedEvent"],
            4
        )
    ]) func parse_realPackets(
        string: String,
        expectedUniqueTypes: [String],
        expectedCount: Int
    ) throws {
        /// new decode!
        let objects = try NextStringProtocol.decodeEventsPack(from: string.data(using: .utf8)!)
        print("\(objects)")
        let uniqueTypes2 = Set(objects.map({ $0.type }))
        #expect(objects.count == expectedCount)
        #expect(uniqueTypes2 == Set(expectedUniqueTypes))
    }
}

