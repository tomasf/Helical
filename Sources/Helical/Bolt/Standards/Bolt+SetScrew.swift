import Cadova

/// Set screws (grub screws) with various point and drive types.
///
/// Headless screws used to secure components to shafts or prevent movement.
/// Available with hex socket or slotted drive, and flat, cone, or dog point.
///
/// Standards:
/// - Flat point: DIN 913/551, ISO 4026/4766
/// - Cone point: DIN 914/553, ISO 4027/7434
/// - Dog point: DIN 915/417, ISO 4028/7435
public extension Bolt {
    /// The point type for a set screw.
    enum SetScrewPointType {
        /// Flat point (DIN 913/551, ISO 4026/4766).
        case flat
        /// Cone point (DIN 914/553, ISO 4027/7434).
        case cone
        /// Dog point with cylindrical extension (DIN 915/417, ISO 4028/7435).
        case dog
    }

    /// The drive type for a set screw.
    enum SetScrewSocketType {
        /// Hexagonal socket (Allen) drive.
        case hexSocket
        /// Slotted (flathead screwdriver) drive.
        case slotted
    }

    /// Creates a standard metric set screw.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - socket: The drive type. Defaults to hex socket.
    ///   - point: The point type. Defaults to flat.
    ///   - length: Nominal length of the set screw.
    static func setScrew(_ size: ScrewThread.ISOMetricSize, socket: SetScrewSocketType = .hexSocket, point: SetScrewPointType = .flat, length: Double) -> Bolt {
        let flatDiameter: Double // flat dp
        let coneDiameter: Double // cone dt
        let dogDiameter: Double // dog dp
        let socketWidth: Double // s
        let socketDepth: Double // socket t
        let slotWidth: Double // n
        let slotDepth: Double // slot t

        (flatDiameter, coneDiameter, dogDiameter, socketWidth, socketDepth, slotWidth, slotDepth) = switch size {
        case .m1:   (0.5, -1,   -1,    -1,  -1,   0.2,  0.4)
        case .m1p2: (0.6, -1,   -1,    -1,  -1,   0.2,  0.4)
        case .m1p4: (0.7, -1,   -1,    0.7, 1.4,  0.2,  0.48)
        case .m1p6: (0.8, 0.4,  0.55,  0.7, 1.5,  0.25, 0.56)
        case .m1p8: (0.9, -1,   -1,    0.7, 1.6,  -1,   -1)
        case .m2:   (1,   0.5,  0.75,  0.9, 1.7,  0.25, 0.64)
        case .m2p5: (1.5, 0.65, 1.25,  1.3, 2,    0.4,  0.72)
        case .m3:   (2,   0.75, 1.75,  1.5, 2,    0.4,  0.8)
        case .m3p5: (2.2, -1,   -1,    -1,  -1,   0.5,  0.96)
        case .m4:   (2.5, 1,    2.25,  2,   2.5,  0.6,  1.12)
        case .m5:   (3.5, 1.25, 3.2,   2.5, 3,    0.8,  1.28)
        case .m6:   (4,   1.5,  3.7,   3,   3.5,  1,    1.6)
        case .m8:   (5.5, 2,    5.2,   4,   5,    1.2,  2)
        case .m10:  (7,   2.5,  6.64,  5,   6,    1.6,  2.4)
        case .m12:  (8.5, 3,    8.14,  6,   8,    2,    2.8)
        case .m14:  (10,  4,    -1,    6,   9,    -1,   -1)
        case .m16:  (12,  4,    11.57, 8,   10,   -1,   -1)
        case .m18:  (13,  5,    -1,    10,  11,   -1,   -1)
        case .m20:  (15,  5,    14.57, 10,  12,   -1,   -1)
        case .m22:  (17,  6,    -1,    12,  13.5, -1,   -1)
        case .m24:  (18,  6,    17.57, 12,  15,   -1,   -1)
        default: (-1, -1, -1, -1, -1, -1, -1)
        }

        let pointDiameter = switch point {
        case .flat: flatDiameter
        case .cone: coneDiameter
        case .dog: dogDiameter
        }

        assert(flatDiameter > 0, "\(size) isn't a valid size for this set screw type")

        if socket == .hexSocket {
            assert(socketWidth > 0, "\(size) isn't a valid size for this set screw type")

            return hexSocketSetScrew(
                .isoMetric(size),
                socketWidth: socketWidth,
                socketDepth: socketDepth,
                pointChamferSize: (size.rawValue - pointDiameter) / 2,
                dogPointLength: point == .dog ? size.rawValue / 2 : 0,
                length: length
            )
        } else {
            assert(slotWidth > 0, "\(size) isn't a valid size for this set screw type")

            return slottedSetScrew(
                .isoMetric(size),
                slotWidth: slotWidth,
                slotDepth: slotDepth,
                pointChamferSize: (size.rawValue - pointDiameter) / 2,
                dogPointLength: point == .dog ? size.rawValue / 2 : 0,
                length: length
            )
        }
    }

    /// Creates a hex socket set screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - socketWidth: Width across the flats of the hex socket.
    ///   - socketDepth: Depth of the hex socket.
    ///   - pointChamferSize: Size of the chamfer at the point.
    ///   - dogPointLength: Length of the dog point extension. Zero for flat/cone points.
    ///   - length: Nominal length of the set screw.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func hexSocketSetScrew(
        _ thread: ScrewThread,
        socketWidth: Double,
        socketDepth: Double,
        pointChamferSize: Double,
        dogPointLength: Double = 0,
        length: Double,
        unthreadedLength: Double = 0
    ) -> Bolt {
        let head = ProfiledBoltHeadShape(edgeProfile: .chamfer(depth: thread.depth))

        return .init(
            thread: thread,
            length: length,
            unthreadedLength: unthreadedLength,
            headShape: head,
            socket: PolygonalBoltHeadSocket(sides: 6, acrossWidth: socketWidth, depth: socketDepth),
            point: .chamfer(depth: pointChamferSize, dogPointLength: dogPointLength)
        )
    }

    /// Creates a slotted set screw with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - slotWidth: Width of the slot.
    ///   - slotDepth: Depth of the slot.
    ///   - pointChamferSize: Size of the chamfer at the point.
    ///   - dogPointLength: Length of the dog point extension. Zero for flat/cone points.
    ///   - length: Nominal length of the set screw.
    ///   - unthreadedLength: Length of the unthreaded portion.
    static func slottedSetScrew(
        _ thread: ScrewThread,
        slotWidth: Double,
        slotDepth: Double,
        pointChamferSize: Double,
        dogPointLength: Double = 0,
        length: Double,
        unthreadedLength: Double = 0
    ) -> Bolt {
        let head = ProfiledBoltHeadShape(edgeProfile: .chamfer(depth: thread.depth))

        return .init(
            thread: thread,
            length: length,
            unthreadedLength: unthreadedLength,
            headShape: head,
            socket: .slot(length: thread.majorDiameter, width: slotWidth, depth: slotDepth),
            point: .chamfer(depth: pointChamferSize, dogPointLength: dogPointLength)
        )
    }
}
