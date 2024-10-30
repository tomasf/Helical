import Foundation
import SwiftSCAD

public struct PolygonalBoltHeadSocket: BoltHeadSocket {
    let sides: Int
    let acrossWidth: Double
    public let depth: Double
    let bottomAngle: Angle?

    public init(sides: Int, acrossWidth: Double, depth: Double, bottomAngle: Angle? = nil) {
        self.sides = sides
        self.acrossWidth = acrossWidth
        self.depth = depth
        self.bottomAngle = bottomAngle
    }

    public var body: any Geometry3D {
        readTolerance { tolerance in
            let polygon = RegularPolygon(sideCount: sides, apothem: (acrossWidth + tolerance) / 2)
            let bottomDepth = bottomAngle.map { polygon.circumradius / tan($0 / 2) } ?? 0

            polygon
                .extruded(height: depth + bottomDepth)
                .intersecting {
                    Cylinder(radius: polygon.circumradius, height: 0.01)
                        .adding {
                            Cylinder(bottomRadius: polygon.circumradius, topRadius: 0, height: bottomDepth)
                                .translated(z: depth)
                        }
                        .convexHull()
                }
        }
    }
}

public extension BoltHeadSocket where Self == PolygonalBoltHeadSocket {
    static func standardHex(width: Double, depth: Double) -> PolygonalBoltHeadSocket {
        .init(sides: 6, acrossWidth: width, depth: depth, bottomAngle: 120°)
    }
}
