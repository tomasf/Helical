import Foundation
import Cadova

// DIN 7991 / ISO 10642
// Metric hex socket countersunk head screw
// https://www.fasteners.eu/standards/ISO/10642/

public extension Bolt {
    /// Standard ISO 10642 configuration
    static func hexSocketCountersunk(_ size: ScrewThread.ISOMetricSize, length: Double, shankLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let socketWidth: Double // s, socket width across flats
        let socketDepth: Double // t

        (headDiameter, socketWidth, socketDepth) = switch size {
        case .m2:   (3.7,   1.3, 0.75)
        case .m2p5: (4.8,   1.5, 1.0)
        case .m3:   (5.54,  2,   1.1)
        case .m4:   (7.53,  2.5, 1.4)
        case .m5:   (9.43,  3,   1.75)
        case .m6:   (11.34, 4,   2.2)
        case .m8:   (15.24, 5,   2.9)
        case .m10:  (19.22, 6,   3.5)
        case .m12:  (23.12, 8,   4.3)
        case .m14:  (26.52, 10,  4.5)
        case .m16:  (29.01, 10,  4.8)
        case .m20:  (35.4,  12,  5.6)
        default: (-1, -1, -1)
        }

        assert(headDiameter > 0, "\(size) isn't a valid size for ISO 10642 bolts")
        return hexSocketCountersunk(.isoMetric(size), headDiameter: headDiameter, socketWidth: socketWidth, socketDepth: socketDepth, length: length, shankLength: shankLength)
    }

    /// Custom configuration
    static func hexSocketCountersunk(_ thread: ScrewThread, headDiameter: Double, socketWidth: Double, socketDepth: Double, length: Double, shankLength: Double = 0) -> Bolt {
        .init(
            thread: thread,
            length: length,
            shankLength: shankLength,
            headShape: .standardCountersunk(topDiameter: headDiameter, boltDiameter: thread.majorDiameter),
            socket: .standardHex(width: socketWidth, depth: socketDepth)
        )
    }
}
