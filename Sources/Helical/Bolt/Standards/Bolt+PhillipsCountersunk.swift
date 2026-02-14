import Cadova

/// Phillips countersunk head screws (DIN 965/966, ISO 7046/7047).
///
/// Flat head screws with a Phillips cross drive. Available in flush (DIN 965) or
/// raised/oval (DIN 966) variants.
/// References:
/// - Flush: <https://www.fasteners.eu/standards/DIN/965/>
/// - Raised: <https://www.fasteners.eu/standards/DIN/966/>
public extension Bolt {
    /// Creates a standard DIN 965/966 Phillips countersunk screw.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - raised: Whether to use a raised (oval) head instead of flush.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
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

    /// Creates a Phillips countersunk screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - headDiameter: Diameter of the countersunk head.
    ///   - lensHeight: Height of the raised lens for oval heads. Zero for flush heads.
    ///   - socketWidth: Width of the Phillips recess.
    ///   - phillipsSize: The Phillips driver size.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
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
        let effectiveUnthreadedLength = max(head.consumedLength + thread.majorDiameter / 10, unthreadedLength)
        return .init(
            thread: thread,
            length: length,
            unthreadedLength: effectiveUnthreadedLength,
            unthreadedDiameter: thread.pitchDiameter,
            headShape: head,
            socket: socket
        )
    }
}
