import Foundation
import Cadova

// DIN 965 / ISO 7046
// Metric cross recessed countersunk head screws
// https://www.fasteners.eu/standards/DIN/965/

// DIN 966 / ISO 7047
// Metric Cross recessed *raised* countersunk head screws
// https://www.fasteners.eu/standards/DIN/966/

public extension Bolt {
    /// Standard configuration
    static func phillipsCountersunk(_ size: ScrewThread.ISOMetricSize, raised: Bool = false, length: Double, unthreadedLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let phillipsSize: PhillipsSize
        let socketWidth: Double // m

        (headDiameter, phillipsSize, socketWidth) = switch size {
        case .m1p6: (3,    .ph0, 1.7)
        case .m2:   (3.8,  .ph1, 2.35)
        case .m2p5: (4.7,  .ph1, 2.7)
        case .m3:   (5.6,  .ph1, 2.9)
        case .m3p5: (6.5,  .ph2, 3.9)
        case .m4:   (7.5,  .ph2, 4.4)
        case .m5:   (9.2,  .ph2, 4.6)
        case .m6:   (11,   .ph3, 6.6)
        case .m8:   (14.5, .ph4, 8.7)
        case .m10:  (18,   .ph4, 9.6)
        default: (-1, .ph0, -1)
        }

        assert(headDiameter > 0, "\(size) isn't a valid size for DIN 963/964 bolts")
        return phillipsCountersunk(
            .isoMetric(size),
            headDiameter: headDiameter,
            lensHeight: raised ? size.rawValue / 4.0 : 0,
            socketWidth: socketWidth,
            phillipsSize: phillipsSize,
            length: length,
            unthreadedLength: unthreadedLength
        )
    }

    /// Custom configuration
    static func phillipsCountersunk(
        _ thread: ScrewThread,
        headDiameter: Double,
        lensHeight: Double = 0,
        socketWidth: Double,
        phillipsSize: PhillipsSize,
        length: Double,
        unthreadedLength: Double = 0
    ) -> Bolt {
        let head = CountersunkBoltHeadShape(
            countersink: .init(angle: 90°, topDiameter: headDiameter),
            boltDiameter: thread.majorDiameter - thread.depth,
            lensHeight: lensHeight
        )
        let socket = PhillipsBoltHeadSocket(size: phillipsSize, width: socketWidth)
        let effectiveunthreadedLength = max(head.consumedLength + thread.majorDiameter / 10, unthreadedLength)
        return .init(
            thread: thread,
            length: length,
            unthreadedLength: effectiveunthreadedLength,
            unthreadedDiameter: thread.pitchDiameter,
            headShape: head,
            socket: socket
        )
    }
}
