import Cadova

/// Torx countersunk head screws (ISO 14581).
///
/// Flat head screws with a hexalobular (Torx) drive.
/// Reference: <https://www.fasteners.eu/standards/ISO/14581/>
public extension Bolt {
    /// Creates a standard ISO 14581 Torx countersunk screw.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func torxCountersunk(_ size: ScrewThread.ISOMetricSize, length: Double, unthreadedLength: Double = 0) -> Bolt {
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
            unthreadedLength: unthreadedLength
        )
    }

    /// Creates a Torx countersunk screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - headDiameter: Diameter of the countersunk head.
    ///   - size: The Torx size designation.
    ///   - socketDepth: Depth of the Torx socket.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func torxCountersunk(
        _ thread: ScrewThread,
        headDiameter: Double,
        size: TorxSize,
        socketDepth: Double,
        length: Double,
        unthreadedLength: Double = 0
    ) -> Bolt {

        let head = CountersunkBoltHeadShape.countersunk(
            topDiameter: headDiameter,
            boltDiameter: thread.majorDiameter - thread.depth
        )
        let effectiveUnthreadedLength = max(head.consumedLength + thread.majorDiameter / 10, unthreadedLength)
        
        return .init(
            thread: thread,
            length: length,
            unthreadedLength: effectiveUnthreadedLength,
            unthreadedDiameter: thread.pitchDiameter,
            headShape: head,
            socket: .torx(size: size, depth: socketDepth)
        )
    }
}
