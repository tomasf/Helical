import Cadova

/// Default clearance height for bolt head recesses, ensuring the recess
/// extends well above the head to cut through any reasonable part thickness.
public let defaultHeadClearance: Double = 100.0

public extension Countersink {
    /// A 3D shape representing a countersink recess with clearance above.
    struct Shape: Shape3D {
        let countersink: Countersink
        let headClearance: Double

        /// Creates a countersink shape for subtraction from a solid.
        ///
        /// - Parameters:
        ///   - countersink: The countersink parameters.
        ///   - headClearance: Height of the cylindrical clearance above the cone.
        public init(_ countersink: Countersink, headClearance: Double = defaultHeadClearance) {
            self.countersink = countersink
            self.headClearance = headClearance
        }

        public var body: any Geometry3D {
            @Environment(\.tolerance) var tolerance
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
        ///   - headClearance: Height of additional clearance above the counterbore.
        public init(_ counterbore: Counterbore, headClearance: Double = defaultHeadClearance) {
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

    init(sideCount: Int, widthAcrossFlats: Double, height: Double, headClearance: Double = defaultHeadClearance) {
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
