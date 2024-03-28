import Foundation
import SwiftSCAD

// DIN 965 / ISO 7046
// Metric cross recessed countersunk head screws
// https://www.fasteners.eu/standards/DIN/965/

// DIN 966 / ISO 7047
// Metric Cross recessed *raised* countersunk head screws
// https://www.fasteners.eu/standards/DIN/966/

public extension Bolt {
    /// Standard configuration
    static func phillipsCountersunk(_ size: ScrewThread.ISOMetricSize, raised: Bool = false, length: Double, shankLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let phillipsSize: PhillipsBoltHeadSocket.Size
        let socketWidth: Double // m

        (headDiameter, phillipsSize, socketWidth) = switch size {
        case .m1p6: (3,    .PH0, 1.7)
        case .m2:   (3.8,  .PH1, 2.35)
        case .m2p5: (4.7,  .PH1, 2.7)
        case .m3:   (5.6,  .PH1, 2.9)
        case .m3p5: (6.5,  .PH2, 3.9)
        case .m4:   (7.5,  .PH2, 4.4)
        case .m5:   (9.2,  .PH2, 4.6)
        case .m6:   (11,   .PH3, 6.6)
        case .m8:   (14.5, .PH4, 8.7)
        case .m10:  (18,   .PH4, 9.6)
        default: (-1, .PH0, -1)
        }

        assert(headDiameter > 0, "\(size) isn't a valid size for DIN 963/964 bolts")
        return phillipsCountersunk(
            .isoMetric(size),
            headDiameter: headDiameter,
            lensHeight: raised ? size.rawValue / 4.0 : 0,
            socketWidth: socketWidth,
            phillipsSize: phillipsSize,
            length: length,
            shankLength: shankLength
        )
    }

    /// Custom configuration
    static func phillipsCountersunk(
        _ thread: ScrewThread,
        headDiameter: Double,
        lensHeight: Double = 0,
        socketWidth: Double,
        phillipsSize: PhillipsBoltHeadSocket.Size,
        length: Double,
        shankLength: Double = 0
    ) -> Bolt {
        let head = CountersunkBoltHeadShape(
            countersink: .init(angle: 90°, topDiameter: headDiameter),
            boltDiameter: thread.majorDiameter - thread.depth,
            bottomFilletRadius: thread.majorDiameter / 10,
            lensHeight: lensHeight
        )
        let socket = PhillipsBoltHeadSocket(size: phillipsSize, width: socketWidth)
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