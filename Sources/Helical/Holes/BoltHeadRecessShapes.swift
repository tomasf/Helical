import Foundation
import Cadova

public extension Countersink {
    /// A 3D shape representing a countersink recess with clearance above.
    struct Shape: Shape3D {
        let countersink: Countersink
        let headClearance: Double

        @Environment(\.tolerance) var tolerance

        /// Creates a countersink shape for subtraction from a solid.
        ///
        /// - Parameters:
        ///   - countersink: The countersink parameters.
        ///   - headClearance: Height of the cylindrical clearance above the cone. Defaults to 100.
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
    /// A 3D shape representing a counterbore recess with clearance above.
    struct Shape: Shape3D {
        let counterbore: Counterbore
        let headClearance: Double

        /// Creates a counterbore shape for subtraction from a solid.
        ///
        /// - Parameters:
        ///   - counterbore: The counterbore parameters.
        ///   - headClearance: Height of additional clearance above the counterbore. Defaults to 100.
        public init(_ counterbore: Counterbore, headClearance: Double = 100.0) {
            self.counterbore = counterbore
            self.headClearance = headClearance
        }
        
        public var body: any Geometry3D {
            @Environment(\.tolerance) var tolerance

            let diameter = counterbore.diameter + tolerance
            Cylinder(diameter: diameter, height: counterbore.depth + headClearance)
                .overhangSafe()
                .translated(z: -headClearance)
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
        @Environment(\.tolerance) var tolerance

        let apothem = (widthAcrossFlats + tolerance) / 2
        RegularPolygon(sideCount: sideCount, apothem: apothem)
            .extruded(height: height + headClearance)
            .translated(z: -headClearance)
    }
}

