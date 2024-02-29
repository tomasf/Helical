import Foundation
import SwiftSCAD

public extension Bolt {
    // Hex socket set screws
    // Flat point, cone point or dog point

    enum SetScrewPointType {
        case flat // DIN 913 / ISO 4026
        case cone // DIN 914 / ISO 4027
        case dog  // DIN 915 / ISO 4028
    }

    static func hexSocketSetScrew(_ size: ScrewThread.ISOMetricSize, point: SetScrewPointType = .flat, length: Double) -> Bolt {
        let flatDiameter: Double // flat dp
        let coneDiameter: Double // cone dt
        let dogDiameter: Double // dog dp
        let socketWidth: Double // s
        let socketDepth: Double // t

        (flatDiameter, coneDiameter, dogDiameter, socketWidth, socketDepth) = switch size {
        case .m1p4: (0.7, -1,   -1,    0.7, 1.4)
        case .m1p6: (0.8, 0.4,  0.55,  0.7, 1.5)
        case .m1p8: (0.9, -1,   -1,    0.7, 1.6)
        case .m2:   (1,   0.5,  0.75,  0.9, 1.7)
        case .m2p5: (1.5, 0.65, 1.25,  1.3, 2)
        case .m3:   (2,   0.75, 1.75,  1.5, 2)
        case .m4:   (2.5, 1,    2.25,  2,   2.5)
        case .m5:   (3.5, 1.25, 3.2,   2.5, 3)
        case .m6:   (4,   1.5,  3.7,   3,   3.5)
        case .m8:   (5.5, 2,    5.2,   4,   5)
        case .m10:  (7,   2.5,  6.64,  5,   6)
        case .m12:  (8.5, 3,    8.14,  6,   8)
        case .m14:  (10,  4,    -1,    6,   9)
        case .m16:  (12,  4,    11.57, 8,   10)
        case .m18:  (13,  5,    -1,    10,  11)
        case .m20:  (15,  5,    14.57, 10,  12)
        case .m22:  (17,  6,    -1,    12, 13.5)
        case .m24:  (18,  6,    17.57, 12,  15)
        default: (-1, -1, -1, -1, -1)
        }

        let pointDiameter = switch point {
        case .flat: flatDiameter
        case .cone: coneDiameter
        case .dog: dogDiameter
        }

        assert(flatDiameter > 0, "\(size) isn't a valid size for this set screw type")

        return hexSocketSetScrew(
            .isoMetric(size),
            socketWidth: socketWidth,
            socketDepth: socketDepth,
            pointChamferSize: (size.rawValue - pointDiameter) / 2,
            dogPointLength: point == .dog ? size.rawValue / 2 : 0,
            length: length
        )
    }

    /// Custom configuration
    static func hexSocketSetScrew(
        _ thread: ScrewThread,
        socketWidth: Double,
        socketDepth: Double,
        pointChamferSize: Double,
        dogPointLength: Double = 0,
        length: Double,
        shankLength: Double = 0
    ) -> Bolt {
        let head = ChamferedBoltHeadShape(thread: thread, edgeProfile: .chamfer(size: thread.depth))

        return .init(
            thread: thread,
            length: length,
            shankLength: shankLength,
            headShape: head,
            socket: PolygonalBoltHeadSocket(sides: 6, acrossWidth: socketWidth, depth: socketDepth),
            point: ChamferedBoltPoint(thread: thread, chamfer: .chamfer(size: pointChamferSize), dogPointLength: dogPointLength)
        )
    }
}
