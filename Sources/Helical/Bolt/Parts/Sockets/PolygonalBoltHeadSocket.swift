import Foundation
import SwiftSCAD

public struct PolygonalBoltHeadSocket: BoltHeadSocket {
    let sides: Int
    let acrossWidth: Double
    public let depth: Double
    let bottomAngle: Angle?

    @EnvironmentValue(\.tolerance) var tolerance

    public init(sides: Int, acrossWidth: Double, depth: Double, bottomAngle: Angle? = nil) {
        self.sides = sides
        self.acrossWidth = acrossWidth
        self.depth = depth
        self.bottomAngle = bottomAngle
    }

    public var body: any Geometry3D {
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
    static func standardHex(width: Double, depth: Double) -> PolygonalBoltHeadSocket {
        .init(sides: 6, acrossWidth: width, depth: depth, bottomAngle: 120°)
    }
}
