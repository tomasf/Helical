import Foundation
import Cadova

public struct Washer: Shape3D {
    let outerDiameter: Double
    let innerDiameter: Double
    let thickness: Double
    let outerTopEdge: EdgeProfile?

    public init(outerDiameter: Double, innerDiameter: Double, thickness: Double, outerTopEdge: EdgeProfile? = nil) {
        self.outerDiameter = outerDiameter
        self.innerDiameter = innerDiameter
        self.thickness = thickness
        self.outerTopEdge = outerTopEdge
    }

    public var body: any Geometry3D {
        readTolerance { tolerance in
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
}
