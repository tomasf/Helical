import Cadova

/// Slotted countersunk head tapping screws (DIN 7972, ISO 1482).
///
/// The same screws as ``Bolt/phillipsCountersunkTapping(_:end:length:)`` with a slotted drive
/// in place of the cross recess; the head dimensions are shared between the two standards.
/// References:
/// - Screw: <https://westfieldfasteners.co.uk/Standards/TappingScrew-SlotCsk.pdf>
/// - Thread: <https://cdn.standards.iteh.ai/samples/6067/1b45920ad91f4f6989a6ef9fd3d1b042/ISO-1478-1983.pdf>
public extension Bolt {
    /// Creates a standard DIN 7972 slotted countersunk tapping screw.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured from the top of the head.
    static func slottedCountersunkTapping(_ size: ScrewThread.TappingSize, end: TappingScrewEnd = .cone, length: Double) -> Bolt {
        let headDiameter: Double // dk
        let slotWidth: Double // n
        let slotDepth: Double // t, midway between the standard's min and max

        (headDiameter, slotWidth, slotDepth) = switch size {
        case .st2p2: (4.3,  0.6, 0.5)
        case .st2p9: (5.5,  0.8, 0.625)
        case .st3p5: (6.8,  1.0, 0.775)
        case .st3p9: (7.5,  1.0, 0.875)
        case .st4p2: (8.1,  1.2, 0.95)
        case .st4p8: (9.5,  1.2, 1.1)
        case .st5p5: (10.8, 1.6, 1.25)
        case .st6p3: (12.4, 1.6, 1.475)
        default: (-1, -1, -1)
        }

        if !(headDiameter > 0) { fatalError("\(size) isn't a valid size for DIN 7972 screws") }
        return slottedCountersunkTapping(
            size,
            headDiameter: headDiameter,
            slotWidth: slotWidth,
            slotDepth: slotDepth,
            end: end,
            length: length
        )
    }

    /// Creates a slotted countersunk tapping screw with custom head dimensions.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - headDiameter: Diameter of the countersunk head.
    ///   - slotWidth: Width of the slot.
    ///   - slotDepth: Depth of the slot.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured from the top of the head.
    static func slottedCountersunkTapping(
        _ size: ScrewThread.TappingSize,
        headDiameter: Double,
        slotWidth: Double,
        slotDepth: Double,
        end: TappingScrewEnd = .cone,
        length: Double
    ) -> Bolt {
        let thread = ScrewThread.tapping(size)
        // Countersunk tapping screw heads are 80 degrees, unlike the 90 degrees of the metric
        // machine screw standards.
        let head = CountersunkBoltHeadShape(
            countersink: .init(angle: 80°, topDiameter: headDiameter),
            boltDiameter: thread.majorDiameter
        )
        let point: any BoltPoint = switch end {
        case .cone: .coneEnd()
        case .flat: .flatEnd(size)
        }

        // Tapping screws are threaded right up to the head, apart from a run-out of
        // one pitch (a), which takes the thread's crest diameter.
        return .init(
            thread: thread,
            length: length,
            unthreadedLength: head.consumedLength + thread.pitch,
            headShape: head,
            socket: SlottedBoltHeadSocket(length: headDiameter, width: slotWidth, depth: slotDepth),
            point: point
        )
    }
}
