import Cadova

/// A polygonal bolt head, such as a hex head or square head.
///
/// Supports configurable side count, chamfered corners, and flat diameter for washer faces.
public struct PolygonalBoltHeadShape: BoltHeadShape {
    let sideCount: Int
    let widthAcrossFlats: Double
    public let height: Double
    let flatDiameter: Double
    let chamferAngle: Angle

    /// Creates a polygonal head with full control over geometry.
    ///
    /// - Parameters:
    ///   - sideCount: Number of sides (6 for hex, 4 for square, etc.).
    ///   - widthAcrossFlats: Distance between opposite flat faces.
    ///   - height: The head height.
    ///   - flatDiameter: Diameter of the flat top surface after chamfering.
    ///   - chamferAngle: Angle of the corner chamfer. Defaults to zero.
    public init(sideCount: Int, widthAcrossFlats: Double, height: Double, flatDiameter: Double, chamferAngle: Angle = 0°) {
        self.sideCount = sideCount
        self.widthAcrossFlats = widthAcrossFlats
        self.height = height
        self.flatDiameter = flatDiameter
        self.chamferAngle = chamferAngle
    }

    /// Creates a polygonal head with chamfered corners.
    ///
    /// - Parameters:
    ///   - sideCount: Number of sides (6 for hex, 4 for square, etc.).
    ///   - widthAcrossFlats: Distance between opposite flat faces.
    ///   - height: The head height.
    ///   - chamferAngle: Angle of the corner chamfer.
    public init(sideCount: Int, widthAcrossFlats: Double, height: Double, chamferAngle: Angle) {
        self.init(sideCount: sideCount, widthAcrossFlats: widthAcrossFlats, height: height, flatDiameter: widthAcrossFlats, chamferAngle: chamferAngle)
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance

        let toleranceScale = (widthAcrossFlats - tolerance) / widthAcrossFlats
        let apothem = (widthAcrossFlats - tolerance) / 2
        let polygon = RegularPolygon(sideCount: sideCount, apothem: apothem)
        let chamferWidth = polygon.circumradius - flatDiameter * toleranceScale / 2
        polygon
            .extruded(height: height)
            .subtracting {
                Rectangle(polygon.circumradius)
                    .rotated(-90° + chamferAngle)
                    .translated(x: polygon.circumradius - chamferWidth)
                    .revolved()
            }
    }

    public var recess: any Geometry3D {
        PolygonalHeadRecess(sideCount: sideCount, widthAcrossFlats: widthAcrossFlats, height: height)
    }
}

public extension BoltHeadShape where Self == PolygonalBoltHeadShape {
    /// A polygonal bolt head with chamfered corners.
    ///
    /// - Parameters:
    ///   - sideCount: Number of sides (6 for hex, 4 for square, etc.).
    ///   - widthAcrossFlats: Distance between opposite flat faces.
    ///   - height: The head height.
    ///   - chamferAngle: Angle of the corner chamfer.
    static func polygon(sideCount: Int, widthAcrossFlats: Double, height: Double, chamferAngle: Angle = 0°) -> Self {
        .init(sideCount: sideCount, widthAcrossFlats: widthAcrossFlats, height: height, chamferAngle: chamferAngle)
    }

    /// A hex bolt head with chamfered corners.
    ///
    /// - Parameters:
    ///   - widthAcrossFlats: Distance between opposite flat faces.
    ///   - height: The head height.
    ///   - chamferAngle: Angle of the corner chamfer.
    static func hex(widthAcrossFlats: Double, height: Double, chamferAngle: Angle = 0°) -> Self {
        .init(sideCount: 6, widthAcrossFlats: widthAcrossFlats, height: height, chamferAngle: chamferAngle)
    }
}
