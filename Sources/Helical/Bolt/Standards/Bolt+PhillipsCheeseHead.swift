import Foundation
import Cadova

// DIN 7985 / ISO 7045
// Metric cross recessed raised cheese head screws
// https://www.fasteners.eu/standards/DIN/7985/

public extension Bolt {
    /// Standard configuration
    static func phillipsCheeseHead(_ size: ScrewThread.ISOMetricSize, length: Double, unthreadedLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let headThickness: Double // k
        let headTopRadius: Double // rf
        let phillipsSize: PhillipsSize
        let socketWidth: Double // m

        (headDiameter, headThickness, headTopRadius, phillipsSize, socketWidth) = switch size {
        case .m1p6: (3.2, 1.3, 3,  .ph0, 1.8)
        case .m2:   (4,   1.6, 4,  .ph1, 2.5)
        case .m2p5: (5,   2,   5,  .ph1, 2.7)
        case .m3:   (6,   2.4, 6,  .ph1, 3.1)
        case .m3p5: (7,   2.7, 7,  .ph2, 4.2)
        case .m4:   (8,   3.1, 8,  .ph2, 4.6)
        case .m5:   (10,  3.8, 10, .ph2, 5.3)
        case .m6:   (12,  4.6, 12, .ph3, 6.8)
        case .m8:   (16,  6,   16, .ph4, 9)
        case .m10:  (20,  7.5, 20, .ph4, 10.2)
        default: (-1, -1, -1, .ph0, -1)
        }

        assert(headDiameter > 0, "\(size) isn't a valid size for DIN 7985 bolts")
        return phillipsCheeseHead(
            .isoMetric(size),
            headDiameter: headDiameter,
            headThickness: headThickness,
            headTopRadius: headTopRadius,
            socketWidth: socketWidth,
            phillipsSize: phillipsSize,
            length: length,
            unthreadedLength: unthreadedLength
        )
    }

    /// Custom configuration
    static func phillipsCheeseHead(
        _ thread: ScrewThread,
        headDiameter: Double,
        headThickness: Double,
        headTopRadius: Double,
        socketWidth: Double,
        phillipsSize: PhillipsSize,
        length: Double,
        unthreadedLength: Double = 0
    ) -> Bolt {
        let head = CylindricalBoltHeadShape(
            diameter: headDiameter,
            height: headThickness,
            roundedTopRadius: headTopRadius
        )
        let socket = PhillipsBoltHeadSocket(size: phillipsSize, width: socketWidth)
        return .init(
            thread: thread,
            length: length,
            unthreadedLength: unthreadedLength,
            unthreadedDiameter: thread.pitchDiameter,
            headShape: head,
            socket: socket
        )
    }
}
