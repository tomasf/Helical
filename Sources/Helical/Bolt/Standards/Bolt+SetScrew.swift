import Foundation
import SwiftSCAD

public extension Bolt {
    // DIN 913/914 / ISO 4026/4027
    // Hex socket set screws, flat point or cone point
    // https://www.fasteners.eu/standards/DIN/913/
    // https://www.fasteners.eu/standards/DIN/914/

    enum SetScrewPointType {
        case flat
        case cone
    }

    static func hexSocketSetScrew(_ size: ScrewThread.ISOMetricSize, point: SetScrewPointType = .flat, length: Double) -> Bolt {
        let flatDiameter: Double // flat dp
        let coneDiameter: Double // cone dt
        let socketWidth: Double // s
        let socketDepth: Double // t

        (flatDiameter, coneDiameter, socketWidth, socketDepth) = switch size {
        case .m1p6: (0.8, 0.4,  0.7, 1.5)
        case .m2:   (1,   0.5,  0.9, 1.7)
        case .m2p5: (1.5, 0.65, 1.3, 2)
        case .m3:   (2,   0.75, 1.5, 2)
        case .m4:   (2.5, 1,    2,   2.5)
        case .m5:   (3.5, 1.25, 2.5, 3)
        case .m6:   (4,   1.5,  3,   3.5)
        case .m8:   (5.5, 2,    4,   5)
        case .m10:  (7,   2.5,  5,   6)
        case .m12:  (8.5, 3,    6,   8)
        case .m14:  (10,  4,    6,   9)
        case .m16:  (12,  4,    8,   10)
        case .m18:  (13,  5,    10,  11)
        case .m20:  (15,  5,    10,  12)
        case .m22:  (17,  6,    12,  13.5)
        case .m24:  (18,  6,    12,  15)
        default: (-1, -1, -1, -1)
        }

        assert(flatDiameter > 0, "\(size) isn't a valid size for DIN 913/914")

        let pointDiameter = switch point {
        case .flat: flatDiameter
        case .cone: coneDiameter
        }
        let pointChamferSize = (size.rawValue - pointDiameter) / 2
        return hexSocketSetScrew(.isoMetric(size), socketWidth: socketWidth, socketDepth: socketDepth, pointChamferSize: pointChamferSize, length: length)
    }

    /// Custom configuration
    static func hexSocketSetScrew(_ thread: ScrewThread, socketWidth: Double, socketDepth: Double, pointChamferSize: Double, length: Double, shankLength: Double = 0) -> Bolt {
        let head = ChamferedBoltHeadShape(thread: thread, edgeProfile: .chamfer(size: thread.depth))

        return .init(
            thread: thread,
            length: length,
            shankLength: shankLength,
            headShape: head,
            socket: PolygonalBoltHeadSocket(sides: 6, acrossWidth: socketWidth, depth: socketDepth),
            point: ChamferedBoltPoint(thread: thread, chamfer: .chamfer(size: pointChamferSize))
        )
    }
}
