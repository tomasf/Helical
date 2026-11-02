import Cadova

/// A cone end that tapers all the way to a point, as used on tapping screws.
///
/// The cone truncates the thread rather than extending it, so the thread disappears
/// where the cone falls below the core diameter. ISO 1478 specifies a 45° included angle
/// for its type C end, and notes that a slight rounding or truncation of the point is
/// desirable; ``tipDiameter`` provides the truncation.
///
/// Unlike ``ProfiledBoltPoint``, the taper reaches the screw axis, which makes this
/// suitable for points rather than chamfers.
public struct ConeEndBoltPoint: BoltPoint {
    /// The included angle of the cone.
    public let angle: Angle
    /// Diameter of the flat at the tip. Zero produces a sharp point.
    public let tipDiameter: Double

    /// Creates a cone end with the specified angle.
    ///
    /// - Parameters:
    ///   - angle: The included angle of the cone. Defaults to the 45° of ISO 1478 type C.
    ///   - tipDiameter: Diameter of the flat at the tip. Defaults to zero, a sharp point.
    public init(angle: Angle = 45°, tipDiameter: Double = 0) {
        self.angle = angle
        self.tipDiameter = tipDiameter
    }

    public var consumedLength: Double { 0 }

    /// The axial length of the cone, measured from the tip to where it meets the thread crest.
    ///
    /// - Parameter thread: The thread the point terminates.
    public func length(for thread: ScrewThread) -> Double {
        length(majorDiameter: thread.majorDiameter)
    }

    private func length(majorDiameter: Double) -> Double {
        (majorDiameter - tipDiameter) / 2 / tan(angle / 2)
    }

    public var negativeBody: any Geometry3D {
        @Environment(\.thread!) var thread
        @Environment(\.tolerance) var tolerance

        let majorDiameter = thread.majorDiameter - tolerance
        let length = length(majorDiameter: majorDiameter)

        Cylinder(diameter: majorDiameter * 2, height: length)
            .subtracting {
                Cylinder(bottomDiameter: tipDiameter, topDiameter: majorDiameter, height: length)
            }
            .flipped(along: .z)
    }
}

public extension BoltPoint where Self == ConeEndBoltPoint {
    /// An ISO 1478 type C cone end, as found on most tapping screws.
    ///
    /// - Parameter tipDiameter: Diameter of the flat at the tip. Defaults to zero, a sharp point.
    static func coneEnd(tipDiameter: Double = 0) -> Self {
        ConeEndBoltPoint(tipDiameter: tipDiameter)
    }
}

public extension BoltPoint where Self == ProfiledBoltPoint {
    /// An ISO 1478 type F flat end for a given tapping screw size.
    ///
    /// The thread tapers out to a blunt end over the length of incomplete thread
    /// given by the standard.
    ///
    /// - Parameter size: The ISO 1478 nominal thread size.
    static func flatEnd(_ size: ScrewThread.TappingSize) -> Self {
        let metrics = TappingThreadMetrics(size: size)
        return ProfiledBoltPoint(
            depth: (metrics.majorDiameter - metrics.flatEndDiameter) / 2,
            length: metrics.flatEndRunout
        )
    }
}
