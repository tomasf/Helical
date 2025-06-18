import Foundation
import Cadova

public struct PolygonalNutBody: NutBody {
    let sideCount: Int
    let thickness: Double
    let widthAcrossFlats: Double
    let topCorners: EdgeProfile?
    let bottomCorners: EdgeProfile?

    public init(
        sideCount: Int,
        thickness: Double,
        widthAcrossFlats: Double,
        topCorners: EdgeProfile? = nil,
        bottomCorners: EdgeProfile? = nil
    ) {
        self.sideCount = sideCount
        self.thickness = thickness
        self.widthAcrossFlats = widthAcrossFlats
        self.topCorners = topCorners
        self.bottomCorners = bottomCorners
    }

    public var body: any Geometry3D {
        @Environment(\.relativeTolerance) var relativeTolerance

        let polygon = RegularPolygon(sideCount: sideCount, apothem: (widthAcrossFlats + relativeTolerance) / 2)
        polygon
            .rotated(180° / Double(sideCount))
            .extruded(height: thickness)
            .intersecting {
                Circle(diameter: polygon.circumradius * 2)
                    .extruded(height: thickness, topEdge: topCorners, bottomEdge: bottomCorners)
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
