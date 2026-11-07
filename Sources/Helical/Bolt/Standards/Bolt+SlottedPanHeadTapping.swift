import Cadova

/// Slotted pan head tapping screws (DIN 7971, ISO 1481).
///
/// A flat topped head with a rounded edge, lower than the crowned head of
/// ``Bolt/phillipsPanHeadTapping(_:end:length:)`` for the same thread size. The standard also
/// drafts the head's side by 5 degrees, which this doesn't model.
/// References:
/// - Screw: <https://westfieldfasteners.co.uk/Standards/TappingScrew-SlotPan.pdf>
/// - Thread: <https://cdn.standards.iteh.ai/samples/6067/1b45920ad91f4f6989a6ef9fd3d1b042/ISO-1478-1983.pdf>
public extension Bolt {
    /// Creates a standard DIN 7971 slotted pan head tapping screw.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured below the head.
    static func slottedPanHeadTapping(_ size: ScrewThread.TappingSize, end: TappingScrewEnd = .cone, length: Double) -> Bolt {
        let headDiameter: Double // dk
        let headThickness: Double // k
        let headEdgeRadius: Double // r2
        let slotWidth: Double // n
        let slotDepth: Double // t, midway between the standard's min and max

        (headDiameter, headThickness, headEdgeRadius, slotWidth, slotDepth) = switch size {
        case .st2p9: (5.6,  1.75, 1.0, 0.8, 0.875)
        case .st3p5: (6.9,  2.1,  1.2, 1.0, 1.1)
        case .st4p2: (8.2,  2.45, 1.3, 1.2, 1.325)
        case .st4p8: (9.5,  2.8,  1.6, 1.2, 1.525)
        case .st5p5: (10.8, 3.2,  2.0, 1.6, 1.75)
        case .st6p3: (12.5, 3.65, 2.2, 1.6, 2.0)
        default: (-1, -1, -1, -1, -1)
        }

        if !(headDiameter > 0) { fatalError("\(size) isn't a valid size for DIN 7971 screws") }
        return slottedPanHeadTapping(
            size,
            headDiameter: headDiameter,
            headThickness: headThickness,
            headEdgeRadius: headEdgeRadius,
            slotWidth: slotWidth,
            slotDepth: slotDepth,
            end: end,
            length: length
        )
    }

    /// Creates a slotted pan head tapping screw with custom head dimensions.
    ///
    /// - Parameters:
    ///   - size: The ISO 1478 tapping screw thread size.
    ///   - headDiameter: Diameter of the head.
    ///   - headThickness: Height of the head.
    ///   - headEdgeRadius: Radius rounding the top edge of the head.
    ///   - slotWidth: Width of the slot.
    ///   - slotDepth: Depth of the slot.
    ///   - end: The form of the screw end. Defaults to the type C cone end.
    ///   - length: Nominal length of the screw, measured below the head.
    static func slottedPanHeadTapping(
        _ size: ScrewThread.TappingSize,
        headDiameter: Double,
        headThickness: Double,
        headEdgeRadius: Double,
        slotWidth: Double,
        slotDepth: Double,
        end: TappingScrewEnd = .cone,
        length: Double
    ) -> Bolt {
        let thread = ScrewThread.tapping(size)
        let head = CylindricalBoltHeadShape(
            diameter: headDiameter,
            height: headThickness,
            topEdge: .fillet(radius: headEdgeRadius)
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
            unthreadedLength: thread.pitch,
            headShape: head,
            socket: SlottedBoltHeadSocket(length: headDiameter, width: slotWidth, depth: slotDepth),
            point: point
        )
    }
}
