import Foundation
import SwiftSCAD

public extension Countersink {
    struct Shape: BoltHeadRecess {
        let countersink: Countersink
        let headClearance: Double

        public init(_ countersink: Countersink, headClearance: Double = 100.0) {
            self.countersink = countersink
            self.headClearance = headClearance
        }

        public var body: any Geometry3D {
            readTolerance { tolerance in
                let topDiameter = countersink.topDiameter + tolerance
                let coneHeight = topDiameter / 2 * tan(countersink.angle / 2)
                OverhangCylinder(diameter: topDiameter, height: headClearance)
                    .translated(z: -headClearance + 0.01)

                OverhangCylinder(bottomDiameter: topDiameter, topDiameter: 0.001, height: coneHeight)
            }
        }
    }
}

public extension Counterbore {
    struct Shape: BoltHeadRecess {
        let counterbore: Counterbore
        let headClearance: Double
        
        public init(_ counterbore: Counterbore, headClearance: Double = 100.0) {
            self.counterbore = counterbore
            self.headClearance = headClearance
        }
        
        public var body: any Geometry3D {
            readTolerance { tolerance in
                let diameter = counterbore.diameter + tolerance
                OverhangCylinder(diameter: diameter, height: counterbore.depth + headClearance)
                    .translated(z: -headClearance)
            }
        }
    }
}

struct PolygonalHeadRecess: BoltHeadRecess {
    let sideCount: Int
    let widthAcrossFlats: Double
    let height: Double
    let headClearance: Double

    init(sideCount: Int, widthAcrossFlats: Double, height: Double, headClearance: Double = 100.0) {
        self.sideCount = sideCount
        self.widthAcrossFlats = widthAcrossFlats
        self.height = height
        self.headClearance = headClearance
    }

    var body: any Geometry3D {
        readTolerance { tolerance in
            let apothem = (widthAcrossFlats + tolerance) / 2
            RegularPolygon(sideCount: sideCount, apothem: apothem)
                .extruded(height: height + headClearance)
                .translated(z: -headClearance)
        }
    }
}

