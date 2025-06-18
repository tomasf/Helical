import Foundation
import Cadova

// ISO 14581
// Hexalobular (Torx) socket countersunk flat head screws
// https://www.fasteners.eu/standards/ISO/14581/

public extension Bolt {
    /// Standard configuration
    static func torxCountersunk(_ size: ScrewThread.ISOMetricSize, length: Double, shankLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let socketDepth: Double // t
        let torxSize: TorxSize

        (headDiameter, socketDepth, torxSize) = switch size {
        case .m2:   (3.8,  0.51, .t6)
        case .m2p5: (4.7,  0.66, .t8)
        case .m3:   (5.5,  0.70, .t10)
        case .m3p5: (7.3,  1.16, .t15)
        case .m4:   (8.4,  1.14, .t20)
        case .m5:   (9.3,  1.12, .t25)
        case .m6:   (11.3, 1.39, .t30)
        case .m8:   (15.8, 2.15, .t45)
        case .m10:  (18.3, 2.41, .t50)
        default: (-1, -1, .t10)
        }

        assert(headDiameter > 0, "\(size) isn't a valid size for ISO 14581 bolts")
        return torxCountersunk(
            .isoMetric(size),
            headDiameter: headDiameter,
            size: torxSize,
            socketDepth: socketDepth,
            length: length,
            shankLength: shankLength
        )
    }

    /// Custom configuration
    static func torxCountersunk(
        _ thread: ScrewThread,
        headDiameter: Double,
        size: TorxSize,
        socketDepth: Double,
        length: Double,
        shankLength: Double = 0
    ) -> Bolt {
        let head = CountersunkBoltHeadShape(
            countersink: .init(angle: 90°, topDiameter: headDiameter),
            boltDiameter: thread.majorDiameter - thread.depth
        )
        let socket = TorxBoltHeadSocket(size: size, depth: socketDepth)
        let effectiveShankLength = max(head.boltLength + thread.majorDiameter / 10, shankLength)
        return .init(
            thread: thread,
            length: length,
            shankLength: effectiveShankLength,
            shankDiameter: thread.pitchDiameter,
            headShape: head,
            socket: socket
        )
    }
}
