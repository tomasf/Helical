import Foundation
import SwiftSCAD

// DIN 964 / ISO 2010
// Metric *raised* slotted countersunk head screws
// https://www.fasteners.eu/standards/DIN/964/

public extension Bolt {
    /// Standard DIN 964 configuration
    static func raisedSlottedCountersunk(_ size: ScrewThread.ISOMetricSize, length: Double, shankLength: Double = 0) -> Bolt {
        let lensHeight = switch size {
        case .m1:   0.25
        case .m1p2: 0.3
        case .m1p4: 0.35
        case .m1p6: 0.4
        case .m2:   0.5
        case .m2p5: 0.6
        case .m3:   0.75
        case .m3p5: 0.9
        case .m4:   1.0
        case .m5:   2.5
        case .m6:   3.0
        case .m8:   4.0
        case .m10:  5.0
        default: -1.0
        }

        assert(lensHeight > 0, "\(size) isn't a valid size for DIN 964 bolts")

        let regularCountersunkBolt = slottedCountersunk(size, length: length, shankLength: shankLength)
        guard let head = regularCountersunkBolt.headShape as? CountersunkBoltHeadShape else {
            fatalError("Unexpected head type for slottedCountersunk bolt")
        }

        return raisedSlottedCountersunk(.isoMetric(size), headDiameter: head.countersink.topDiameter, lensHeight: lensHeight, length: length, shankLength: shankLength)
    }

    /// Custom configuration
    static func raisedSlottedCountersunk(_ thread: ScrewThread, headDiameter: Double, lensHeight: Double, length: Double, shankLength: Double = 0) -> Bolt {
        let head = RaisedCountersunkBoltHeadShape(
            countersink: .init(angle: 90°, topDiameter: headDiameter),
            boltDiameter: thread.majorDiameter - thread.depth,
            radius: thread.majorDiameter / 10,
            lensHeight: lensHeight
        )
        let effectiveShankLength = max(head.boltLength + thread.majorDiameter / 10, shankLength)

        return .init(
            thread: thread,
            length: length,
            shankLength: effectiveShankLength,
            shankDiameter: thread.majorDiameter - thread.depth,
            headShape: head,
            socket: SlottedBoltHeadSocket(
                length: headDiameter,
                width: headDiameter * 0.14,
                depth: headDiameter * 0.13 + lensHeight
            )
        )
    }
}
