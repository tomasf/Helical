import Foundation
import SwiftSCAD

public struct CylindricalBoltHeadShape: BoltHeadShape {
    let diameter: Double
    public let height: Double
    let topEdge: EdgeProfile
    let bottomEdge: EdgeProfile

    public init(diameter: Double, height: Double, topEdge: EdgeProfile = .sharp, bottomEdge: EdgeProfile = .sharp) {
        self.diameter = diameter
        self.height = height
        self.topEdge = topEdge
        self.bottomEdge = bottomEdge
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            Circle(diameter: diameter - environment.tolerance)
                .extruded(height: height, topEdge: bottomEdge, bottomEdge: topEdge, method: .convexHull)
        }
    }

    public var recess: (any BoltHeadRecess)? {
        Counterbore.Shape(.init(diameter: diameter, depth: height))
    }
}

public extension BoltHeadShape where Self == CylindricalBoltHeadShape {
    static func cylindrical(diameter: Double, height: Double, topEdge: EdgeProfile = .sharp, bottomEdge: EdgeProfile = .sharp) -> Self {
        CylindricalBoltHeadShape(diameter: diameter, height: height, topEdge: topEdge, bottomEdge: bottomEdge)
    }
}
