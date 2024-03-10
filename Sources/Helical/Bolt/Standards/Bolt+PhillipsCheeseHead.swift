import Foundation
import SwiftSCAD

// DIN 7985 / ISO 7045
// Metric cross recessed raised cheese head screws
// https://www.fasteners.eu/standards/DIN/7985/

public extension Bolt {
    /// Standard configuration
    static func phillipsCheeseHead(_ size: ScrewThread.ISOMetricSize, length: Double, shankLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let headThickness: Double // k
        let headTopRadius: Double // rf
        let phillipsSize: PhillipsBoltHeadSocket.Size
        let socketWidth: Double // m

        (headDiameter, headThickness, headTopRadius, phillipsSize, socketWidth) = switch size {
        case .m1p6: (3.2, 1.3, 3,  .PH0, 1.8)
        case .m2:   (4,   1.6, 4,  .PH1, 2.5)
        case .m2p5: (5,   2,   5,  .PH1, 2.7)
        case .m3:   (6,   2.4, 6,  .PH1, 3.1)
        case .m3p5: (7,   2.7, 7,  .PH2, 4.2)
        case .m4:   (8,   3.1, 8,  .PH2, 4.6)
        case .m5:   (10,  3.8, 10, .PH2, 5.3)
        case .m6:   (12,  4.6, 12, .PH3, 6.8)
        case .m8:   (16,  6,   16, .PH4, 9)
        case .m10:  (20,  7.5, 20, .PH4, 10.2)
        default: (-1, -1, -1, .PH0, -1)
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
            shankLength: shankLength
        )
    }

    /// Custom configuration
    static func phillipsCheeseHead(
        _ thread: ScrewThread,
        headDiameter: Double,
        headThickness: Double,
        headTopRadius: Double,
        socketWidth: Double,
        phillipsSize: PhillipsBoltHeadSocket.Size,
        length: Double,
        shankLength: Double = 0
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
            shankLength: shankLength,
            shankDiameter: thread.pitchDiameter,
            headShape: head,
            socket: socket
        )
    }
}
