import Cadova

/// Phillips pan head tapping screws (DIN 7981, ISO 7049).
///
/// Self-tapping screws with a crowned pan head and a Phillips cross drive. The same screws as
/// ``Bolt/phillipsCountersunkTapping(_:end:length:)`` apart from the head, and the usual choice
/// where the head may stand above the surface.
/// References:
/// - Screw: <https://westfieldfasteners.co.uk/Standards/TappingScrew-PhilPan.pdf>
/// - Thread: <https://cdn.standards.iteh.ai/samples/6067/1b45920ad91f4f6989a6ef9fd3d1b042/ISO-1478-1983.pdf>
public extension Bolt {
    /// Creates a standard DIN 7981 Phillips pan head tapping screw.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured below the head.
    static func phillipsPanHeadTapping(_ size: ScrewThread.TappingSize, end: TappingScrewEnd = .cone, length: Double) -> Bolt {
        let headDiameter: Double // dk
        let headThickness: Double // k
        let headTopRadius: Double // rf
        let phillipsSize: PhillipsSize
        let socketWidth: Double // m

        (headDiameter, headThickness, headTopRadius, phillipsSize, socketWidth) = switch size {
        case .st2p2: (4.2,  1.8,  3.4, .ph1, 2.6)
        case .st2p9: (5.6,  2.2,  4.4, .ph1, 3.0)
        case .st3p5: (6.9,  2.6,  5.4, .ph2, 4.2)
        case .st3p9: (7.5,  2.8,  5.8, .ph2, 4.4)
        case .st4p2: (8.2,  3.05, 6.2, .ph2, 4.6)
        case .st4p8: (9.5,  3.55, 7.2, .ph2, 5.0)
        case .st5p5: (10.8, 3.95, 8.2, .ph3, 6.5)
        case .st6p3: (12.5, 4.55, 9.5, .ph3, 7.1)
        default: (-1, -1, -1, .ph0, -1)
        }

        if !(headDiameter > 0) { fatalError("\(size) isn't a valid size for DIN 7981 screws") }
        return phillipsPanHeadTapping(
            size,
            headDiameter: headDiameter,
            headThickness: headThickness,
            headTopRadius: headTopRadius,
            socketWidth: socketWidth,
            phillipsSize: phillipsSize,
            end: end,
            length: length
        )
    }

    /// Creates a Phillips pan head tapping screw with custom head dimensions.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - headDiameter: Diameter of the head.
    ///   - headThickness: Height of the head.
    ///   - headTopRadius: Radius of the head's spherical crown.
    ///   - socketWidth: Width of the Phillips recess.
    ///   - phillipsSize: The Phillips driver size.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured below the head.
    static func phillipsPanHeadTapping(
        _ size: ScrewThread.TappingSize,
        headDiameter: Double,
        headThickness: Double,
        headTopRadius: Double,
        socketWidth: Double,
        phillipsSize: PhillipsSize,
        end: TappingScrewEnd = .cone,
        length: Double
    ) -> Bolt {
        let thread = ScrewThread.tapping(size)
        let head = CylindricalBoltHeadShape(
            diameter: headDiameter,
            height: headThickness,
            roundedTopRadius: headTopRadius
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
            unthreadedLength: thread.pitch,
            unthreadedDiameter: thread.minorDiameter,
            headShape: head,
            socket: PhillipsBoltHeadSocket(size: phillipsSize, width: socketWidth),
            point: point
        )
    }
}
