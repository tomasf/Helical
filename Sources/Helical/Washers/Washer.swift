import Foundation
import SwiftSCAD

public struct Washer: Shape3D {
    let outerDiameter: Double
    let innerDiameter: Double
    let thickness: Double
    let outerTopEdge: EdgeProfile

    public init(outerDiameter: Double, innerDiameter: Double, thickness: Double, outerTopEdge: EdgeProfile = .sharp) {
        self.outerDiameter = outerDiameter
        self.innerDiameter = innerDiameter
        self.thickness = thickness
        self.outerTopEdge = outerTopEdge
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            Circle(diameter: outerDiameter - environment.tolerance)
                .subtracting {
                    Circle(diameter: innerDiameter + environment.tolerance)
                }
                .extruded(height: thickness)
                .subtracting {
                    outerTopEdge.shape()
                        .flipped(along: .xy)
                        .translated(x: (outerDiameter - environment.tolerance) / 2 + 0.01, y: 0.01)
                        .extruded()
                        .translated(z: thickness)
                }
        }
    }
}