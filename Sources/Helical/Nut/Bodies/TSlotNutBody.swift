import Cadova

/// A T-slot nut body for use in extruded aluminum profiles.
///
/// Has a wide base that sits in the T-slot channel and a narrower neck that
/// extends through the slot opening.
public struct TSlotNutBody: NutBody {
    let baseSize: Vector3D
    let slotWidth: Double
    let fullHeight: Double
    let bottomProfile: EdgeProfile?

    /// Creates a T-slot nut body with the specified dimensions.
    ///
    /// - Parameters:
    ///   - baseSize: Size of the base portion that sits in the T-slot channel.
    ///   - slotWidth: Width of the neck that passes through the slot opening.
    ///   - fullHeight: Total height of the nut.
    ///   - bottomProfile: Optional edge profile on the bottom of the base.
    public init(baseSize: Vector3D, slotWidth: Double, fullHeight: Double, bottomProfile: EdgeProfile?) {
        self.baseSize = baseSize
        self.slotWidth = slotWidth
        self.fullHeight = fullHeight
        self.bottomProfile = bottomProfile
    }

    public var body: any Geometry3D {
        @Environment(\.relativeTolerance) var tol
        let effectiveBaseSize = baseSize + Vector3D(x: tol, y: tol)

        Stack(.z) {
            Box(effectiveBaseSize)
                .aligned(at: .centerXY)
                .replaced(if: bottomProfile) { input, bottomProfile in
                    input.cuttingEdgeProfile(bottomProfile, on: .bottom, along: .x)
                }

            Box(x: effectiveBaseSize.x, y: slotWidth + tol, z: fullHeight - baseSize.z)
                .aligned(at: .centerXY)
        }
    }

    public func nutTrap(depthClearance: Double) -> any Geometry3D {
        Self(
            baseSize: baseSize + .z(depthClearance),
            slotWidth: slotWidth,
            fullHeight: fullHeight + depthClearance,
            bottomProfile: nil
        )
    }

    public var threadedDepth: Double { fullHeight }
}
