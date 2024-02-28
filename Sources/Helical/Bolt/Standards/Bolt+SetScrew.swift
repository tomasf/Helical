import Foundation
import SwiftSCAD

public extension Bolt {
    // DIN 913 / ISO 4026
    // Hex socket set screws, flat point
    // https://www.fasteners.eu/standards/DIN/913/

    static func hexSocketSetScrew(_ size: ScrewThread.ISOMetricSize, length: Double) -> Bolt {
        let pointDiameter: Double // dp
        let socketWidth: Double // s
        let socketDepth: Double // t

        (pointDiameter, socketWidth, socketDepth) = switch size {
        case .m1p4: (0.7, 0.7, 1.4)
        case .m1p6: (0.8, 0.7, 1.5)
        case .m1p8: (0.9, 0.7, 1.6)
        case .m2:   (1,   0.9, 1.7)
        case .m2p5: (1.5, 1.3, 2)
        case .m3:   (2,   1.5, 2)
        case .m4:   (2.5, 2,   2.5)
        case .m5:   (3.5, 2.5, 3)
        case .m6:   (4,   3,   3.5)
        case .m8:   (5.5, 4,   5)
        case .m10:  (7,   5,   6)
        case .m12:  (8.5, 6,   8)
        case .m14:  (10,  6,   9)
        case .m16:  (12,  8,   10)
        case .m18:  (13,  10,  11)
        case .m20:  (15,  10,  12)
        case .m22:  (17,  12,  13.5)
        case .m24:  (18,  12,  15)
        default: (-1, -1, -1)
        }

        assert(pointDiameter > 0, "\(size) isn't a valid size for DIN 913 bolts")

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
