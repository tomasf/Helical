import Foundation
import Cadova

/// T-slot nuts (DIN 508, ISO 299).
///
/// Nuts designed for use in T-slot channels of extruded aluminum profiles.
public extension Nut {
    /// Creates a T-slot nut with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - baseSize: Size of the base portion that sits in the T-slot channel.
    ///   - slotWidth: Width of the neck that passes through the slot opening.
    ///   - fullHeight: Total height of the nut.
    ///   - chamferDepth: Depth of the chamfer on the base edges.
    static func tSlotNut(_ thread: ScrewThread, baseSize: Vector3D, slotWidth: Double, fullHeight: Double, chamferDepth: Double) -> Nut {
        let body = TSlotNutBody(baseSize: baseSize, slotWidth: slotWidth, fullHeight: fullHeight, bottomProfile: .chamfer(depth: chamferDepth))
        return .init(thread: thread, shape: body, innerChamferAngle: 90°)
    }

    /// Creates a standard DIN 508 T-slot nut.
    ///
    /// - Parameter size: The ISO metric thread size.
    static func tSlotNut(_ size: ScrewThread.ISOMetricSize) -> Nut {
        let baseXY, baseHeight, slotWidth, fullHeight, chamferDepth: Double

        (baseXY, baseHeight, slotWidth, fullHeight, chamferDepth) = switch size {
        case .m4:  (9,  3,  5,  6.5, 1)
        case .m5:  (10, 4,  6,  8,   1.6)
        case .m6:  (13, 6,  8,  10,  1.6)
        case .m8:  (15, 6,  10, 12,  1.6)
        case .m10: (18, 7,  12, 14,  2.5)
        case .m12: (22, 8,  14, 16,  2.5)
        case .m16: (28, 10, 18, 20,  2.5)
        case .m20: (35, 14, 22, 28,  2.5)
        case .m24: (44, 18, 28, 36,  4)
        case .m30: (54, 22, 36, 44,  6)
        case .m36: (65, 26, 42, 52,  6)
        case .m42: (75, 30, 48, 60,  6)
        case .m48: (85, 34, 54, 70,  6)
        default: (0, 0, 0, 0, 0)
        }

        assert(baseXY > 0, "\(size) isn't a valid size for this kind of nut")
        return tSlotNut(
            .isoMetric(size),
            baseSize: Vector3D(baseXY, baseXY, baseHeight),
            slotWidth: slotWidth,
            fullHeight: fullHeight,
            chamferDepth: chamferDepth
        )
    }
}
