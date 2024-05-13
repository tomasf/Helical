import Foundation
import SwiftSCAD

public struct PolygonalNutBody: NutBody {
    let sideCount: Int
    let thickness: Double
    let widthAcrossFlats: Double
    let topCorners: EdgeProfile
    let bottomCorners: EdgeProfile

    public init(
        sideCount: Int,
        thickness: Double,
        widthAcrossFlats: Double,
        topCorners: EdgeProfile = .sharp,
        bottomCorners: EdgeProfile = .sharp
    ) {
        self.sideCount = sideCount
        self.thickness = thickness
        self.widthAcrossFlats = widthAcrossFlats
        self.topCorners = topCorners
        self.bottomCorners = bottomCorners
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            let polygon = RegularPolygon(sideCount: sideCount, apothem: (widthAcrossFlats + environment.relativeTolerance) / 2)
            polygon
                .rotated(180° / Double(sideCount))
                .extruded(height: thickness)
                .intersection {
                    Circle(diameter: polygon.circumradius * 2)
                        .extruded(height: thickness, topEdge: topCorners, bottomEdge: bottomCorners, method: .convexHull)
                }
        }
    }

    public func nutTrap(depthClearance: Double) -> any Geometry3D {
        EnvironmentReader { environment in
            RegularPolygon(sideCount: sideCount, apothem: (widthAcrossFlats + environment.tolerance) / 2)
                .rotated(180° / Double(sideCount))
                .extruded(height: thickness + depthClearance)
        }
    }

    public var threadedDepth: Double { thickness }
}
