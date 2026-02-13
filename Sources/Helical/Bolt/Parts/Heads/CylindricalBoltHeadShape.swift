import Foundation
import Cadova

/// A cylindrical bolt head, such as those used for socket head cap screws or button head screws.
///
/// Supports optional edge profiles on top and bottom, or a spherically rounded top.
public struct CylindricalBoltHeadShape: BoltHeadShape {
    let diameter: Double
    public let height: Double
    let topEdge: EdgeProfile?
    let bottomEdge: EdgeProfile?
    let roundedTopRadius: Double?

    /// Creates a cylindrical head with optional edge profiles.
    ///
    /// - Parameters:
    ///   - diameter: The head diameter.
    ///   - height: The head height.
    ///   - topEdge: Optional edge profile for the top edge.
    ///   - bottomEdge: Optional edge profile for the bottom edge.
    public init(diameter: Double, height: Double, topEdge: EdgeProfile? = nil, bottomEdge: EdgeProfile? = nil) {
        self.diameter = diameter
        self.height = height
        self.topEdge = topEdge
        self.bottomEdge = bottomEdge
        self.roundedTopRadius = nil
    }

    /// Creates a cylindrical head with a spherically rounded top, such as a button head.
    ///
    /// - Parameters:
    ///   - diameter: The head diameter.
    ///   - height: The head height.
    ///   - roundedTopRadius: Radius of the sphere used to round the top.
    public init(diameter: Double, height: Double, roundedTopRadius: Double) {
        self.diameter = diameter
        self.height = height
        self.topEdge = nil
        self.bottomEdge = nil
        self.roundedTopRadius = roundedTopRadius
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance

        Circle(diameter: diameter - tolerance)
            .extruded(height: height, topEdge: bottomEdge, bottomEdge: topEdge)
            .intersecting {
                if let roundedTopRadius {
                    Sphere(radius: roundedTopRadius)
                        .aligned(at: .minZ)
                }
            }
    }

    public var recess: any Geometry3D {
        Counterbore.Shape(.init(diameter: diameter, depth: height))
    }
}

public extension BoltHeadShape where Self == CylindricalBoltHeadShape {
    /// A cylindrical bolt head with optional edge profiles.
    ///
    /// - Parameters:
    ///   - diameter: The head diameter.
    ///   - height: The head height.
    ///   - topEdge: Optional edge profile for the top edge.
    ///   - bottomEdge: Optional edge profile for the bottom edge.
    static func cylinder(
        diameter: Double,
        height: Double,
        topEdge: EdgeProfile? = nil,
        bottomEdge: EdgeProfile? = nil
    ) -> Self {
        CylindricalBoltHeadShape(diameter: diameter, height: height, topEdge: topEdge, bottomEdge: bottomEdge)
    }
}
