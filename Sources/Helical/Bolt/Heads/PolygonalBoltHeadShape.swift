import Foundation
import SwiftSCAD

struct PolygonalBoltHeadShape: BoltHeadShape {
    let sideCount: Int
    let widthAcrossFlats: Double
    let height: Double
    let flatDiameter: Double
    let chamferAngle: Angle

    init(sideCount: Int, widthAcrossFlats: Double, height: Double, flatDiameter: Double, chamferAngle: Angle = 0°) {
        self.sideCount = sideCount
        self.widthAcrossFlats = widthAcrossFlats
        self.height = height
        self.flatDiameter = flatDiameter
        self.chamferAngle = chamferAngle
    }

    init(sideCount: Int, widthAcrossFlats: Double, height: Double, chamferAngle: Angle) {
        self.init(sideCount: sideCount, widthAcrossFlats: widthAcrossFlats, height: height, flatDiameter: widthAcrossFlats, chamferAngle: chamferAngle)
    }

    var body: any Geometry3D {
        EnvironmentReader { environment in
            let toleranceScale = (widthAcrossFlats - environment.tolerance) / widthAcrossFlats
            let apothem = (widthAcrossFlats - environment.tolerance) / 2
            let polygon = RegularPolygon(sideCount: sideCount, apothem: apothem)
            let chamferWidth = polygon.circumradius - flatDiameter * toleranceScale / 2
            polygon
                .extruded(height: height)
                .intersection {
                    Circle(radius: polygon.circumradius)
                        .extruded(height: height, bottomEdge: .chamfer(width: chamferWidth, angle: chamferAngle), method: .convexHull)
                }
        }
    }

    var recess: any BoltHeadRecess {
        PolygonalHeadRecess(sideCount: sideCount, widthAcrossFlats: widthAcrossFlats, height: height)
    }
}
