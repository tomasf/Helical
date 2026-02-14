import Cadova

/// Slotted countersunk head screws (DIN 963/964, ISO 2009/2010).
///
/// Flat head screws with a slotted drive. Available in flush (DIN 963) or
/// raised/oval (DIN 964) variants.
/// References:
/// - Flush: <https://www.fasteners.eu/standards/DIN/963/>
/// - Raised: <https://www.fasteners.eu/standards/DIN/964/>
public extension Bolt {
    /// Creates a standard DIN 963/964 slotted countersunk screw.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - raised: Whether to use a raised (oval) head instead of flush.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func slottedCountersunk(
        _ size: ScrewThread.ISOMetricSize,
        raised: Bool = false,
        length: Double,
        unthreadedLength: Double = 0
    ) -> Bolt {
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

        if !(headDiameter > 0) { fatalError("\(size) isn't a valid size for DIN 963/964 bolts") }
        return slottedCountersunk(
            .isoMetric(size),
            headDiameter: headDiameter,
            lensHeight: raised ? size.rawValue / 4.0 : 0,
            length: length,
            unthreadedLength: unthreadedLength
        )
    }

    /// Creates a slotted countersunk screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - headDiameter: Diameter of the countersunk head.
    ///   - lensHeight: Height of the raised lens for oval heads. Zero for flush heads.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func slottedCountersunk(
        _ thread: ScrewThread,
        headDiameter: Double,
        lensHeight: Double = 0,
        length: Double,
        unthreadedLength: Double = 0
    ) -> Bolt {
        let head = CountersunkBoltHeadShape(
            countersink: .init(angle: 90°, topDiameter: headDiameter),
            boltDiameter: thread.majorDiameter - thread.depth,
            lensHeight: lensHeight
        )
        let socket = SlottedBoltHeadSocket(
            length: headDiameter,
            width: headDiameter * 0.14,
            depth: headDiameter * 0.13 + lensHeight
        )
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
