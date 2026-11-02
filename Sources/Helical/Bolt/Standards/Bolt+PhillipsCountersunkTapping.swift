import Cadova

/// Phillips countersunk head tapping screws (DIN 7982, ISO 7050).
///
/// Self-tapping screws with a flat countersunk head and a Phillips cross drive, which form
/// their own mating thread in sheet metal or plastic. Head dimensions follow DIN 7982; the
/// superseding ISO 7050 changes the head height and diameter of some sizes.
/// References:
/// - Screw: <https://westfieldfasteners.co.uk/Standards/TappingScrew-PhilCsk.pdf>
/// - Thread: <https://cdn.standards.iteh.ai/samples/6067/1b45920ad91f4f6989a6ef9fd3d1b042/ISO-1478-1983.pdf>
public extension Bolt {
    /// Creates a standard DIN 7982 Phillips countersunk tapping screw.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured from the top of the head.
    static func phillipsCountersunkTapping(_ size: ScrewThread.TappingSize, end: TappingScrewEnd = .cone, length: Double) -> Bolt {
        let headDiameter: Double // dk
        let phillipsSize: PhillipsSize
        let socketWidth: Double // m

        (headDiameter, phillipsSize, socketWidth) = switch size {
        case .st2p2: (4.3,  .ph1, 2.5)
        case .st2p9: (5.5,  .ph1, 3.0)
        case .st3p5: (6.8,  .ph2, 4.2)
        case .st3p9: (7.5,  .ph2, 4.6)
        case .st4p2: (8.1,  .ph2, 4.7)
        case .st4p8: (9.5,  .ph2, 5.1)
        case .st5p5: (10.8, .ph3, 6.8)
        case .st6p3: (12.4, .ph3, 7.1)
        default: (-1, .ph0, -1)
        }

        if !(headDiameter > 0) { fatalError("\(size) isn't a valid size for DIN 7982 screws") }
        return phillipsCountersunkTapping(
            size,
            headDiameter: headDiameter,
            socketWidth: socketWidth,
            phillipsSize: phillipsSize,
            end: end,
            length: length
        )
    }

    /// Creates a Phillips countersunk tapping screw with custom head dimensions.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - headDiameter: Diameter of the countersunk head.
    ///   - socketWidth: Width of the Phillips recess.
    ///   - phillipsSize: The Phillips driver size.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured from the top of the head.
    static func phillipsCountersunkTapping(
        _ size: ScrewThread.TappingSize,
        headDiameter: Double,
        socketWidth: Double,
        phillipsSize: PhillipsSize,
        end: TappingScrewEnd = .cone,
        length: Double
    ) -> Bolt {
        let thread = ScrewThread.tapping(size)
        let head = CountersunkBoltHeadShape(
            countersink: .init(angle: 90°, topDiameter: headDiameter),
            boltDiameter: thread.minorDiameter
        )
        let point: any BoltPoint = switch end {
        case .cone: .coneEnd()
        case .flat: .flatEnd(size)
        }

        // Tapping screws are threaded right up to the head, apart from a run-out of
        // one pitch (a).
        return .init(
            thread: thread,
            length: length,
            unthreadedLength: head.consumedLength + thread.pitch,
            unthreadedDiameter: thread.minorDiameter,
            headShape: head,
            socket: PhillipsBoltHeadSocket(size: phillipsSize, width: socketWidth),
            point: point
        )
    }
}
