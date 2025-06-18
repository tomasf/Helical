import Foundation
import Cadova

public struct ClearanceHole: Shape3D {
    let diameter: Double
    let depth: Double
    let edgeProfile: EdgeProfile?
    let boltHeadRecess: any Geometry3D

    @Environment(\.tolerance) var tolerance

    public init(diameter: Double, depth: Double, boltHeadRecess: any Geometry3D) {
        self.diameter = diameter
        self.depth = depth
        self.edgeProfile = nil
        self.boltHeadRecess = boltHeadRecess
    }

    public init(diameter: Double, depth: Double, edgeProfile: EdgeProfile?) {
        self.diameter = diameter
        self.depth = depth
        self.edgeProfile = edgeProfile
        self.boltHeadRecess = Empty()
    }

    public var body: any Geometry3D {
        Union {
            let effectiveDiameter = diameter + tolerance
            Cylinder(diameter: effectiveDiameter, height: depth)
                .overhangSafe()

            boltHeadRecess
                .ifEmpty {
                    if let edgeProfile {
                        edgeProfile.profile
                            .translated(x: effectiveDiameter / 2)
                            .revolved()
                    }
                }
        }
    }
}
