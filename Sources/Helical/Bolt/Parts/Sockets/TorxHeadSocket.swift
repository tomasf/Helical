import Foundation
import SwiftSCAD


internal struct TorxShape: Shape2D {
    let size: TorxSize

    var body: any Geometry2D {
        let outerDiameter = size.outerDiameter

        Circle(diameter: 0.72 * outerDiameter)
            .adding {
                Circle(radius: 0.1 * outerDiameter)
                    .translated(x: 0.4 * outerDiameter)
                    .repeated(count: 6)
            }
            .rounded(amount: 0.175 * outerDiameter, side: .inside)
    }
}

public struct TorxBoltHeadSocket: BoltHeadSocket {
    public let size: TorxSize
    public let depth: Double

    public var body: any Geometry3D {
        readEnvironment { e in
            let outerDiameter = size.outerDiameter + e.tolerance
            let cone = Cylinder(bottomDiameter: outerDiameter, topDiameter: 0, apexAngle: 120°)

            TorxShape(size: size)
                .offset(amount: e.tolerance / 2, style: .round)
                .extruded(height: depth + cone.height)
                .intersection {
                    Stack(.z, alignment: .center) {
                        Cylinder(diameter: outerDiameter, height: depth)
                        cone
                    }
                }
        }
    }
}
