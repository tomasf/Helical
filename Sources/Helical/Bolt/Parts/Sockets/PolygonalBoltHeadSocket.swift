import Foundation
import Cadova

/// A polygonal drive socket, such as a hex (Allen) socket.
public struct PolygonalBoltHeadSocket: BoltHeadSocket {
    let sides: Int
    let acrossWidth: Double
    let bottomAngle: Angle?
    public let depth: Double

    /// Creates a polygonal socket with the specified geometry.
    ///
    /// - Parameters:
    ///   - sides: Number of sides (6 for hex, 4 for square, etc.).
    ///   - acrossWidth: Width across the flats.
    ///   - depth: Depth of the socket.
    ///   - bottomAngle: Optional angle for a conical bottom. Defaults to flat.
    public init(sides: Int, acrossWidth: Double, depth: Double, bottomAngle: Angle? = nil) {
        self.sides = sides
        self.acrossWidth = acrossWidth
        self.depth = depth
        self.bottomAngle = bottomAngle
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance
        let polygon = RegularPolygon(sideCount: sides, apothem: (acrossWidth + tolerance) / 2)
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
        .init(sides: sides, acrossWidth: width, depth: depth, bottomAngle: bottomAngle)
    }

    /// Creates a standard hex socket with a 120° conical bottom.
    ///
    /// - Parameters:
    ///   - width: Width across the flats.
    ///   - depth: Depth of the socket.
    static func standardHex(width: Double, depth: Double) -> PolygonalBoltHeadSocket {
        .init(sides: 6, acrossWidth: width, depth: depth, bottomAngle: 120°)
    }
}
