import Foundation
import Cadova
import Helical

let boltLength = 20.0

let customThread = ScrewThread.square(majorDiameter: 8, pitch: 2, starts: 2)
let customBolt = Bolt(
    thread: customThread,
    length: boltLength,
    shankLength: 0,
    leadinChamferSize: 1.0,
    headShape: PolygonalBoltHeadShape(sideCount: 8, widthAcrossFlats: 12, height: 3, chamferAngle: 40°),
    socket: PolygonalBoltHeadSocket(sides: 4, acrossWidth: 5, depth: 2)
)

let bolts = [
    ("Hex head, M8", Bolt.hexHead(.m8, length: boltLength)),
    ("Hex socket head cap, M6", Bolt.hexSocketHeadCap(.m6, length: boltLength, shankLength: 10)),
    ("Phillips cheese head, M5", Bolt.phillipsCheeseHead(.m5, length: boltLength)),
    ("Hex socket countersunk, M5", Bolt.hexSocketCountersunk(.m5, length: boltLength)),
    ("Phillips countersunk, M5", Bolt.phillipsCountersunk(.m8, length: boltLength)),
    ("Phillips raised countersunk, M4", Bolt.phillipsCountersunk(.m4, raised: true, length: boltLength, shankLength: 7)),
    ("Slotted countersunk, M5", Bolt.slottedCountersunk(.m5, length: boltLength)),
    ("Raised slotted countersunk, M3", Bolt.slottedCountersunk(.m3, raised: true, length: boltLength)),
    ("Hex socket set screw, dog point, M6", Bolt.setScrew(.m6, socket: .hexSocket, point: .dog, length: boltLength)),
    ("Slotted set screw, flat, M5", Bolt.setScrew(.m5, socket: .slotted, point: .flat, length: boltLength)),
    ("Custom non-standard bolt with square thread", customBolt)
]
    .map { ($0, $1.rotated(x: 180°)) }

let nutsAndWashers: [(String, any Geometry3D)] = [
    ("Hex nut, M8", Nut.hex(.m8)),
    ("Square nut, M6", Nut.square(.m6)),
    ("Thin square nut, M10", Nut.square(.m10, series: .thin)),
    ("Flanged hex nut, M6", Nut.flangedHex(.m6)),
    ("T-slot nut, M8", Nut.tSlotNut(.m8)),
    ("Custom non-standard nut", Nut(thread: customThread, shape: PolygonalNutBody(sideCount: 8, thickness: 10, widthAcrossFlats: 12), innerChamferAngle: 60°)),
    ("Normal washer, M5", Washer.plain(.m5, series: .normal)),
    ("Large washer, M5", Washer.plain(.m5, series: .large))
]

struct Repertoire: Shape3D {
    let contents: [(label: String, part: any Geometry3D)]

    var body: any Geometry3D {
        Stack(.y) {
            for (_, part) in contents { part }
        }
        .measuringBounds { _, bounds in
            let partWidth = bounds.size.x

            Stack(.y, spacing: 5) {
                for (label, part) in contents {
                    part
                        .translated(x: partWidth / 2)
                        .adding {
                            Text(label)
                                .aligned(at: .centerY)
                                .translated(x: partWidth + 3)
                                .extruded(height: 0.1)
                        }
                }
            }
        }
    }
}

await Model("bolts") {
    Repertoire(contents: bolts)
}

await Model("nutsAndWashers") {
    Repertoire(contents: nutsAndWashers)
}
