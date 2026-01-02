import Foundation
import Cadova

/// Phillips raised cheese head screws (DIN 7985, ISO 7045).
///
/// Pan head screws with a Phillips cross drive and rounded top.
/// Reference: <https://www.fasteners.eu/standards/DIN/7985/>
public extension Bolt {
    /// Creates a standard DIN 7985 Phillips cheese head screw.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
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

    /// Creates a Phillips cheese head screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - headDiameter: Diameter of the head.
    ///   - headThickness: Height of the head.
    ///   - headTopRadius: Radius of the spherical top.
    ///   - socketWidth: Width of the Phillips recess.
    ///   - phillipsSize: The Phillips driver size.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
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
