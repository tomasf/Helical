import Foundation
import Cadova

public extension Countersink {
    struct Shape: Shape3D {
        let countersink: Countersink
        let headClearance: Double

        @Environment(\.tolerance) var tolerance

        public init(_ countersink: Countersink, headClearance: Double = 100.0) {
            self.countersink = countersink
            self.headClearance = headClearance
        }

        public var body: any Geometry3D {
            let topDiameter = countersink.topDiameter + tolerance
            let coneHeight = topDiameter / 2 * tan(countersink.angle / 2)
            Cylinder(diameter: topDiameter, height: headClearance)
                .overhangSafe()
                .translated(z: -headClearance)

            Cylinder(bottomDiameter: topDiameter, topDiameter: 0, height: coneHeight)
                .overhangSafe()
        }
    }
}

public extension Counterbore {
    struct Shape: Shape3D {
        let counterbore: Counterbore
        let headClearance: Double
        
        public init(_ counterbore: Counterbore, headClearance: Double = 100.0) {
            self.counterbore = counterbore
            self.headClearance = headClearance
        }
        
        public var body: any Geometry3D {
            readTolerance { tolerance in
                let diameter = counterbore.diameter + tolerance
                Cylinder(diameter: diameter, height: counterbore.depth + headClearance)
                    .overhangSafe()
                    .translated(z: -headClearance)
            }
        }
    }
}

struct PolygonalHeadRecess: Shape3D {
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

