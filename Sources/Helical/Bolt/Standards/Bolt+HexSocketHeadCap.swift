import Cadova

/// Hex socket head cap screws (DIN 912, ISO 4762).
///
/// Cylindrical head screws with a hexagonal socket drive, commonly known as Allen bolts.
/// Reference: <https://www.fasteners.eu/standards/DIN/912/>
public extension Bolt {
    /// Creates a standard DIN 912 hex socket head cap screw.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func hexSocketHeadCap(_ size: ScrewThread.ISOMetricSize, length: Double, unthreadedLength: Double = 0) -> Bolt {
        let headDiameter: Double // dk
        let socketWidth: Double // s, socket width across flats

        (headDiameter, socketWidth) = switch size {
        case .m1p6: (3.00,  1.5)
        case .m2:   (3.80,  1.5)
        case .m2p5: (4.50,  2)
        case .m3:   (5.50,  2.5)
        case .m4:   (7.00,  3)
        case .m5:   (8.50,  4)
        case .m6:   (10.00, 5)
        case .m8:   (13.00, 6)
        case .m10:  (16.00, 8)
        case .m12:  (18.00, 10)
        case .m14:  (21.00, 12)
        case .m16:  (24.00, 14)
        case .m20:  (30.00, 17)
        case .m24:  (36.00, 19)
        case .m30:  (45.00, 22)
        case .m36:  (54.00, 27)
        case .m42:  (63.00, 32)
        case .m48:  (72.00, 36)
        case .m56:  (84.00, 41)
        case .m64:  (96.00, 46)
        default: (-1, -1)
        }

        assert(headDiameter > 0 && socketWidth > 0, "\(size) isn't a valid size for DIN 912 bolts")
        return hexSocketHeadCap(.isoMetric(size), headDiameter: headDiameter, socketWidth: socketWidth, length: length, unthreadedLength: unthreadedLength)
    }

    /// Creates a hex socket head cap screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - headDiameter: Diameter of the cylindrical head.
    ///   - socketWidth: Width across the flats of the hex socket.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func hexSocketHeadCap(_ thread: ScrewThread, headDiameter: Double, socketWidth: Double, length: Double, unthreadedLength: Double = 0) -> Bolt {
        let head = CylindricalBoltHeadShape(
            diameter: headDiameter,
            height: thread.majorDiameter,
            topEdge: .chamfer(depth: thread.majorDiameter / 10.0)
        )
        let socket = PolygonalBoltHeadSocket(
            sides: 6,
            width: socketWidth,
            depth: thread.majorDiameter / 2,
            bottomAngle: 120°
        )
        return .init(
            thread: thread,
            length: length,
            unthreadedLength: unthreadedLength,
            headShape: head,
            socket: socket
        )
    }
}
