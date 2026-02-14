import Cadova

/// A polygonal drive socket, such as a hex (Allen) socket.
public struct PolygonalBoltHeadSocket: BoltHeadSocket {
    let sides: Int
    /// Width across the flats.
    let width: Double
    let bottomAngle: Angle?
    public let depth: Double

    /// Creates a polygonal socket with the specified geometry.
    ///
    /// - Parameters:
    ///   - sides: Number of sides (6 for hex, 4 for square, etc.).
    ///   - width: Width across the flats.
    ///   - depth: Depth of the socket.
    ///   - bottomAngle: Optional angle for a conical bottom. Defaults to flat.
    public init(sides: Int, width: Double, depth: Double, bottomAngle: Angle? = nil) {
        self.sides = sides
        self.width = width
        self.depth = depth
        self.bottomAngle = bottomAngle
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance
        let polygon = RegularPolygon(sideCount: sides, apothem: (width + tolerance) / 2)
        let bottomDepth = bottomAngle.map { polygon.circumradius / tan($0 / 2) } ?? 0

        polygon
            .extruded(height: depth + bottomDepth)
            .intersecting {
                Stack(.z, alignment: .center) {
                    Cylinder(radius: polygon.circumradius, height: depth)
                    Cylinder(bottomRadius: polygon.circumradius, topRadius: 0, height: bottomDepth)
                }
            }
    }
}

public extension BoltHeadSocket where Self == PolygonalBoltHeadSocket {
    /// A polygonal drive socket.
    ///
    /// - Parameters:
    ///   - sides: Number of sides (6 for hex, 4 for square, etc.).
    ///   - width: Width across the flats.
    ///   - depth: Depth of the socket.
    ///   - bottomAngle: Optional angle for a conical bottom. Defaults to flat.
    static func polygon(sides: Int, width: Double, depth: Double, bottomAngle: Angle? = nil) -> Self {
        .init(sides: sides, width: width, depth: depth, bottomAngle: bottomAngle)
    }

    /// A standard hex socket with a 120° conical bottom.
    ///
    /// - Parameters:
    ///   - width: Width across the flats.
    ///   - depth: Depth of the socket.
    static func standardHex(width: Double, depth: Double) -> Self {
        .init(sides: 6, width: width, depth: depth, bottomAngle: 120°)
    }
}
