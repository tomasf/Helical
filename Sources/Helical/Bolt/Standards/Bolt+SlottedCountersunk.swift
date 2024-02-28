import Foundation
import SwiftSCAD

// DIN 963 / ISO 2009
// Metric slotted countersunk head screws
// https://www.fasteners.eu/standards/DIN/963/

extension Bolt {
    /// Standard DIN 963 configuration
    static func slottedCountersunk(_ size: ScrewThread.ISOMetricSize, length: Double, shankLength: Double = 0) -> Bolt {
        let headDiameter = switch size {
        case .m1:   1.9
        case .m1p2: 2.3
        case .m1p4: 2.6
        case .m1p6: 3.0
        case .m2:   3.8
        case .m2p5: 4.7
        case .m3:   5.6
        case .m3p5: 6.5
        case .m4:   7.5
        case .m5:   9.2
        case .m6:   11.0
        case .m8:   14.5
        case .m10:  18.0
        case .m12:  22.0
        case .m14:  25.0
        case .m16:  29.0
        case .m18:  33.0
        case .m20:  36.0
        default: -1.0
        }

        assert(headDiameter > 0, "\(size) isn't a valid size for DIN 963 bolts")
        return slottedCountersunk(.isoMetric(size), headDiameter: headDiameter, length: length, shankLength: shankLength)
    }

    /// Custom configuration
    static func slottedCountersunk(_ thread: ScrewThread, headDiameter: Double, length: Double, shankLength: Double = 0) -> Bolt {
        let head = CountersunkBoltHeadShape(
            countersink: .init(angle: 90°, topDiameter: headDiameter),
            boltDiameter: thread.majorDiameter - thread.depth,
            bottomFilletRadius: thread.majorDiameter / 10
        )
        let socket = SlottedBoltHeadSocket(length: headDiameter, width: headDiameter * 0.14, depth: headDiameter * 0.13)
        let effectiveShankLength = max(head.boltLength + thread.majorDiameter / 10, shankLength)
        return .init(
            thread: thread,
            length: length,
            shankLength: effectiveShankLength,
            shankDiameter: thread.pitchDiameter,
            leadinChamferSize: thread.depth,
            headShape: head,
            socket: socket
        )
    }
}
