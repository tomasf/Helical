import Foundation
import Cadova

// DIN 912 / ISO 4762
// Metric hex socket head cap bolts
// https://www.fasteners.eu/standards/DIN/912/

public extension Bolt {
    /// Standard DIN 912 configuration
    static func hexSocketHeadCap(_ size: ScrewThread.ISOMetricSize, length: Double, shankLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let socketWidth: Double // s, socket width across flats

        (headDiameter, socketWidth) = switch size {
        case .m1p6: (3.00,  1.5)
        case .m2:   (3.80,  1.5)
        case .m2p5: (4.50,  2)
        case .m3:   (5.50,  2.5)
        case .m4:   (7.00,  3)
        case .m5:   (8.50,  4)
        case .m6:   (10.00, 5)
        case .m8:   (13.00, 6)
        case .m10:  (16.00, 8)
        case .m12:  (18.00, 10)
        case .m14:  (21.00, 12)
        case .m16:  (24.00, 14)
        case .m20:  (30.00, 17)
        case .m24:  (36.00, 19)
        case .m30:  (45.00, 22)
        case .m36:  (54.00, 27)
        case .m42:  (63.00, 32)
        case .m48:  (72.00, 36)
        case .m56:  (84.00, 41)
        case .m64:  (96.00, 46)
        default: (-1, -1)
        }

        assert(headDiameter > 0 && socketWidth > 0, "\(size) isn't a valid size for DIN 912 bolts")
        return hexSocketHeadCap(.isoMetric(size), headDiameter: headDiameter, socketWidth: socketWidth, length: length, shankLength: shankLength)
    }

    /// Custom configuration
    static func hexSocketHeadCap(_ thread: ScrewThread, headDiameter: Double, socketWidth: Double, length: Double, shankLength: Double = 0) -> Bolt {
        let head = CylindricalBoltHeadShape(
            diameter: headDiameter,
            height: thread.majorDiameter,
            topEdge: .chamfer(depth: thread.majorDiameter / 10.0)
        )
        let socket = PolygonalBoltHeadSocket(
            sides: 6,
            acrossWidth: socketWidth,
            depth: thread.majorDiameter / 2,
            bottomAngle: 120°
        )
        return .init(
            thread: thread,
            length: length,
            shankLength: shankLength,
            headShape: head,
            socket: socket
        )
    }
}
