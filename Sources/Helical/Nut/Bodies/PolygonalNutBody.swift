import Foundation
import Cadova

/// A polygonal nut body shape, such as hex or square.
///
/// Supports configurable chamfers on the top and bottom corners.
public struct PolygonalNutBody: NutBody {
    let sideCount: Int
    let thickness: Double
    let widthAcrossFlats: Double
    let chamferAngle: Angle?
    let topChamferDepth: Double
    let bottomChamferDepth: Double

    /// Creates a polygonal nut body with the specified geometry.
    ///
    /// - Parameters:
    ///   - sideCount: Number of sides (6 for hex, 4 for square, etc.).
    ///   - thickness: Height of the nut.
    ///   - widthAcrossFlats: Distance between opposite flat faces.
    ///   - chamferAngle: Angle of the corner chamfers.
    ///   - topChamferDepth: Radial depth of the top chamfer.
    ///   - bottomChamferDepth: Radial depth of the bottom chamfer.
    public init(
        sideCount: Int,
        thickness: Double,
        widthAcrossFlats: Double,
        chamferAngle: Angle? = nil,
        topChamferDepth: Double = 0,
        bottomChamferDepth: Double = 0
    ) {
        self.sideCount = sideCount
        self.thickness = thickness
        self.widthAcrossFlats = widthAcrossFlats
        self.chamferAngle = chamferAngle
        self.topChamferDepth = topChamferDepth
        self.bottomChamferDepth = bottomChamferDepth
    }

    public var body: any Geometry3D {
        @Environment(\.relativeTolerance) var relativeTolerance

        let polygon = RegularPolygon(sideCount: sideCount, apothem: (widthAcrossFlats + relativeTolerance) / 2)
        polygon
            .rotated(180° / Double(sideCount))
            .extruded(height: thickness)
            .intersecting {
                if let chamferAngle {
                    let apexAngle = 180° - chamferAngle * 2
                    if topChamferDepth > 0 {
                        let top = Cylinder(
                            bottomDiameter: polygon.circumradius * 2,
                            topDiameter: (polygon.circumradius - topChamferDepth) * 2,
                            apexAngle: apexAngle
                        )
                        Stack(.z) {
                            Cylinder(radius: polygon.circumradius, height: thickness - top.height)
                            top
                        }
                    }
                    if bottomChamferDepth > 0 {
                        let bottom = Cylinder(
                            bottomDiameter: (polygon.circumradius - bottomChamferDepth) * 2,
                            topDiameter: polygon.circumradius * 2,
                            apexAngle: apexAngle
                        )
                        Stack(.z) {
                            bottom
                            Cylinder(radius: polygon.circumradius, height: thickness - bottom.height)
                        }
                    }
                }
            }
    }

    public func nutTrap(depthClearance: Double) -> any Geometry3D {
        @Environment(\.tolerance) var tolerance

        RegularPolygon(sideCount: sideCount, apothem: (widthAcrossFlats + tolerance) / 2)
                .rotated(180° / Double(sideCount))
                .extruded(height: thickness + depthClearance)
    }

    public var threadedDepth: Double { thickness }
}
