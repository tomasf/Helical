import Cadova

/// Hex head bolts (DIN 931/933, ISO 4014/4017).
///
/// Standard metric hex head bolts with chamfered corners.
/// Reference: <https://www.fasteners.eu/standards/DIN/931/>
public extension Bolt {
    /// Creates a standard DIN 931 hex head bolt.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func hexHead(_ size: ScrewThread.ISOMetricSize, length: Double, unthreadedLength: Double = 0) -> Bolt {
        let headHeight: Double // k
        let widthAcrossFlats: Double // s

        (headHeight, widthAcrossFlats) = switch size {
        case .m1p6: (1.1,  3.2)
        case .m2:   (1.4,  4)
        case .m2p5: (1.7,  5)
        case .m3:   (2,    5.5)
        case .m4:   (2.8,  7)
        case .m5:   (3.5,  8)
        case .m6:   (4,    10)
        case .m8:   (5.3,  13)
        case .m10:  (6.4,  16)
        case .m12:  (7.5,  18)
        case .m16:  (10,   24)
        case .m20:  (12.5, 30)
        case .m24:  (15,   36)
        case .m30:  (18.7, 46)
        case .m36:  (22.5, 55)
        case .m42:  (26,   65)
        case .m48:  (30,   75)
        case .m56:  (35,   85)
        case .m64:  (40,   95)
        default: (-1, -1)
        }

        assert(headHeight > 0, "\(size) isn't a valid size for DIN 931 bolts")
        return hexHead(.isoMetric(size), headWidth: widthAcrossFlats, headHeight: headHeight, length: length, unthreadedLength: unthreadedLength)
    }

    /// Creates a hex head bolt with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - headWidth: Width across the flats of the hex head.
    ///   - headHeight: Height of the head.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func hexHead(_ thread: ScrewThread, headWidth: Double, headHeight: Double, length: Double, unthreadedLength: Double = 0) -> Bolt {
        let head = PolygonalBoltHeadShape(
            sideCount: 6,
            widthAcrossFlats: headWidth,
            height: headHeight,
            chamferAngle: 30°
        )
        return .init(thread: thread, length: length, unthreadedLength: unthreadedLength, headShape: head)
    }
}
