import Cadova

/// Hex socket countersunk head screws (DIN 7991, ISO 10642).
///
/// Flat head screws with a hexagonal socket drive.
/// Reference: <https://www.fasteners.eu/standards/ISO/10642/>
public extension Bolt {
    /// Creates a standard ISO 10642 hex socket countersunk screw.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func hexSocketCountersunk(_ size: ScrewThread.ISOMetricSize, length: Double, unthreadedLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let socketWidth: Double // s, socket width across flats
        let socketDepth: Double // t

        // dk is the nominal (maximum) head diameter. The minimum would seat only the
        // smallest head of the tolerance range flush, leaving larger ones standing proud.
        // M2 and M2.5 fall outside the standard's range and follow its dk = 2d pattern.
        (headDiameter, socketWidth, socketDepth) = switch size {
        case .m2:   (4.0,  1.3, 0.75)
        case .m2p5: (5.0,  1.5, 1.0)
        case .m3:   (6.0,  2,   1.1)
        case .m4:   (8.0,  2.5, 1.4)
        case .m5:   (10.0, 3,   1.75)
        case .m6:   (12.0, 4,   2.2)
        case .m8:   (16.0, 5,   2.9)
        case .m10:  (20.0, 6,   3.5)
        case .m12:  (24.0, 8,   4.3)
        case .m14:  (27.0, 10,  4.5)
        case .m16:  (30.0, 10,  4.8)
        case .m20:  (36.0, 12,  5.6)
        default: (-1, -1, -1)
        }

        if !(headDiameter > 0) { fatalError("\(size) isn't a valid size for ISO 10642 bolts") }
        return hexSocketCountersunk(.isoMetric(size), headDiameter: headDiameter, socketWidth: socketWidth, socketDepth: socketDepth, length: length, unthreadedLength: unthreadedLength)
    }

    /// Creates a hex socket countersunk screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - headDiameter: Diameter of the countersunk head.
    ///   - socketWidth: Width across the flats of the hex socket.
    ///   - socketDepth: Depth of the hex socket.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func hexSocketCountersunk(_ thread: ScrewThread, headDiameter: Double, socketWidth: Double, socketDepth: Double, length: Double, unthreadedLength: Double = 0) -> Bolt {
        .init(
            thread: thread,
            length: length,
            unthreadedLength: unthreadedLength,
            headShape: .countersunk(topDiameter: headDiameter, boltDiameter: thread.majorDiameter),
            socket: .standardHex(width: socketWidth, depth: socketDepth)
        )
    }
}
