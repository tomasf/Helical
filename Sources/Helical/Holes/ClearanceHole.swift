import Foundation
import SwiftSCAD

public struct ClearanceHole: Shape3D {
    let diameter: Double
    let depth: Double
    let edgeProfile: EdgeProfile?
    let boltHeadRecess: (any BoltHeadRecess)?

    public init(diameter: Double, depth: Double, boltHeadRecess: (any BoltHeadRecess)?) {
        self.diameter = diameter
        self.depth = depth
        self.edgeProfile = nil
        self.boltHeadRecess = boltHeadRecess
    }

    public init(diameter: Double, depth: Double, edgeProfile: EdgeProfile?) {
        self.diameter = diameter
        self.depth = depth
        self.edgeProfile = edgeProfile
        self.boltHeadRecess = nil
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            let effectiveDiameter = diameter + environment.tolerance
            OverhangCylinder(diameter: effectiveDiameter, height: depth + 0.02)
            if let boltHeadRecess {
                boltHeadRecess
            } else {
                if let edgeProfile {
                    edgeProfile.shape()
                        .translated(x: effectiveDiameter / 2 - 0.01)
                        .extruded()
                }
            }
        }
        .translated(z: -0.01)
    }
}
