import Cadova

/// A flat washer with configurable dimensions.
public struct Washer: Shape3D {
    let outerDiameter: Double
    let innerDiameter: Double
    let thickness: Double
    let outerTopEdge: EdgeProfile?

    /// Creates a washer with the specified dimensions.
    ///
    /// - Parameters:
    ///   - outerDiameter: The outer diameter of the washer.
    ///   - innerDiameter: The inner (hole) diameter of the washer.
    ///   - thickness: The thickness of the washer.
    ///   - outerTopEdge: Optional edge profile on the outer top edge.
    public init(outerDiameter: Double, innerDiameter: Double, thickness: Double, outerTopEdge: EdgeProfile? = nil) {
        self.outerDiameter = outerDiameter
        self.innerDiameter = innerDiameter
        self.thickness = thickness
        self.outerTopEdge = outerTopEdge
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance
        
        Circle(diameter: outerDiameter - tolerance)
            .subtracting {
                Circle(diameter: innerDiameter + tolerance)
            }
            .extruded(height: thickness)
            .subtracting {
                if let outerTopEdge {
                    outerTopEdge.profile
                        .translated(x: (outerDiameter - tolerance) / 2 + 0.01, y: 0.01)
                        .revolved()
                        .translated(z: thickness)
                }
            }
    }
}
