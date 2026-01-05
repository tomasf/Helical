import Foundation
import Cadova

/// A nut body with an integrated washer-like flange at the base.
public struct FlangedNutBody: NutBody {
    let base: any NutBody
    let bottomDiameter: Double
    let roundingDiameter: Double
    let angle: Angle

    /// Creates a flanged nut body wrapping another nut body.
    ///
    /// - Parameters:
    ///   - base: The base nut body shape (typically polygonal).
    ///   - bottomDiameter: Diameter at the bottom of the flange.
    ///   - roundingDiameter: Diameter of the rounding at the flange edge.
    ///   - angle: Angle of the flange surface from horizontal.
    public init(base: any NutBody, bottomDiameter: Double, roundingDiameter: Double, angle: Angle) {
        self.base = base
        self.bottomDiameter = bottomDiameter
        self.roundingDiameter = roundingDiameter
        self.angle = angle
    }

    private var extendedDiameter: Double {
        let xOffset = cos(90° - angle) * (roundingDiameter / 2)
        let yOffset = sin(90° - angle) * (roundingDiameter / 2)

        let height = yOffset + (roundingDiameter / 2)
        return bottomDiameter + 2 * (height / tan(angle) + xOffset)
    }

    public var body: any Geometry3D {
        base.body

        @Environment(\.relativeTolerance) var relativeTolerance
        let baseRadius = extendedDiameter / 2 + relativeTolerance

        Polygon([
            [-baseRadius, 0],
            [baseRadius, 0],
            [0, tan(angle) * baseRadius]
        ])
        .rounded(radius: roundingDiameter / 2)
        .revolved()
    }

    public func nutTrap(depthClearance: Double) -> any Geometry3D {
        @Environment(\.tolerance) var tolerance

        base.measuringBounds { _, baseBounds in
            Cylinder(diameter: extendedDiameter + tolerance, height: baseBounds.size.z + depthClearance)
        }
    }

    public var threadedDepth: Double { base.threadedDepth }
}
