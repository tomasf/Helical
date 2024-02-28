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
        EnvironmentReader { environment in
            let polygon = RegularPolygon(sideCount: sides, apothem: (acrossWidth + environment.tolerance) / 2)
            polygon
                .extruded(height: depth)
                .adding {
                    if let bottomAngle {
                        let bottomDepth = polygon.circumradius / tan(bottomAngle / 2)
                        RegularPolygon(sideCount: sides, circumradius: 0.001)
                            .extruded(height: 0.001)
                            .translated(z: depth + bottomDepth)
                    }
                }
                .convexHull()
        }
    }
}

public extension BoltHeadSocket where Self == PolygonalBoltHeadSocket {
    static func standardHex(width: Double, depth: Double) -> PolygonalBoltHeadSocket {
        .init(sides: 6, acrossWidth: width, depth: depth, bottomAngle: 120°)
    }
}
