import Foundation
import Cadova

public struct TSlotNutBody: NutBody {
    let baseSize: Vector3D
    let slotWidth: Double
    let fullHeight: Double
    let bottomProfile: EdgeProfile?

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
                    input.applyingEdgeProfile(bottomProfile, to: .bottom, along: .x)
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
