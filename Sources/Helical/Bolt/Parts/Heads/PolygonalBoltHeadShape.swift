import Foundation
import SwiftSCAD

public struct PolygonalBoltHeadShape: BoltHeadShape {
    let sideCount: Int
    let widthAcrossFlats: Double
    public let height: Double
    let flatDiameter: Double
    let chamferAngle: Angle

    public init(sideCount: Int, widthAcrossFlats: Double, height: Double, flatDiameter: Double, chamferAngle: Angle = 0°) {
        self.sideCount = sideCount
        self.widthAcrossFlats = widthAcrossFlats
        self.height = height
        self.flatDiameter = flatDiameter
        self.chamferAngle = chamferAngle
    }

    public init(sideCount: Int, widthAcrossFlats: Double, height: Double, chamferAngle: Angle) {
        self.init(sideCount: sideCount, widthAcrossFlats: widthAcrossFlats, height: height, flatDiameter: widthAcrossFlats, chamferAngle: chamferAngle)
    }

    public var body: any Geometry3D {
        readTolerance { tolerance in
            let toleranceScale = (widthAcrossFlats - tolerance) / widthAcrossFlats
            let apothem = (widthAcrossFlats - tolerance) / 2
            let polygon = RegularPolygon(sideCount: sideCount, apothem: apothem)
            let chamferWidth = polygon.circumradius - flatDiameter * toleranceScale / 2
            polygon
                .extruded(height: height)
                .applyingBottomEdgeProfile(.chamfer(width: chamferWidth, angle: chamferAngle), at: 0, method: .convexHull) {
                    Circle(radius: polygon.circumradius)
                }
        }
    }

    public var recess: (any BoltHeadRecess)? {
        PolygonalHeadRecess(sideCount: sideCount, widthAcrossFlats: widthAcrossFlats, height: height)
    }
}
