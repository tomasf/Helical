import Foundation
import SwiftSCAD

extension Countersink {
    struct Shape: BoltHeadRecess {
        let countersink: Countersink
        let headClearance: Double

        init(_ countersink: Countersink, headClearance: Double = 0) {
            self.countersink = countersink
            self.headClearance = headClearance
        }

        var body: any Geometry3D {
            EnvironmentReader { environment in
                let topDiameter = countersink.topDiameter + environment.tolerance
                let coneHeight = topDiameter / 2 * tan(countersink.angle / 2)
                Cylinder(diameter: topDiameter, height: headClearance)
                    .translated(z: -headClearance + 0.01)
                Cylinder(bottomDiameter: topDiameter, topDiameter: 0.001, height: coneHeight)
            }
        }
    }
}

extension Counterbore {
    struct Shape: BoltHeadRecess {
        let counterbore: Counterbore
        let headClearance: Double
        
        init(_ counterbore: Counterbore, headClearance: Double = 0) {
            self.counterbore = counterbore
            self.headClearance = headClearance
        }
        
        var body: any Geometry3D {
            EnvironmentReader { environment in
                let diameter = counterbore.diameter + environment.tolerance
                Cylinder(diameter: diameter, height: counterbore.depth + headClearance)
            }
        }
    }
}

struct PolygonalHeadRecess: BoltHeadRecess {
    let sideCount: Int
    let widthAcrossFlats: Double
    let height: Double

    var body: any Geometry3D {
        EnvironmentReader { environment in
            let apothem = (widthAcrossFlats + environment.tolerance) / 2
            RegularPolygon(sideCount: sideCount, apothem: apothem)
                .extruded(height: height)
        }
    }
}

