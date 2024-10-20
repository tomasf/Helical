import Foundation
import SwiftSCAD

public struct CylindricalBoltHeadShape: BoltHeadShape {
    let diameter: Double
    public let height: Double
    let topEdge: EdgeProfile?
    let bottomEdge: EdgeProfile?
    let roundedTopRadius: Double?

    public init(diameter: Double, height: Double, topEdge: EdgeProfile? = nil, bottomEdge: EdgeProfile? = nil) {
        self.diameter = diameter
        self.height = height
        self.topEdge = topEdge
        self.bottomEdge = bottomEdge
        self.roundedTopRadius = nil
    }

    public init(diameter: Double, height: Double, roundedTopRadius: Double) {
        self.diameter = diameter
        self.height = height
        self.topEdge = nil
        self.bottomEdge = nil
        self.roundedTopRadius = roundedTopRadius
    }

    public var body: any Geometry3D {
        readTolerance { tolerance in
            Circle(diameter: diameter - tolerance)
                .extruded(height: height, topEdge: bottomEdge, bottomEdge: topEdge, method: .convexHull)
                .intersection {
                    if let roundedTopRadius {
                        Sphere(radius: roundedTopRadius)
                            .translated(z: roundedTopRadius)
                    }
                }
        }
    }

    public var recess: (any BoltHeadRecess)? {
        Counterbore.Shape(.init(diameter: diameter, depth: height))
    }
}

public extension BoltHeadShape where Self == CylindricalBoltHeadShape {
    static func cylindrical(diameter: Double, height: Double, topEdge: EdgeProfile? = nil, bottomEdge: EdgeProfile? = nil) -> Self {
        CylindricalBoltHeadShape(diameter: diameter, height: height, topEdge: topEdge, bottomEdge: bottomEdge)
    }
}
