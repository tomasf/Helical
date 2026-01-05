import Foundation
import Cadova

/// A clearance hole for a bolt to pass through without threading.
///
/// Supports optional edge profiles, countersinks, or custom head recesses.
public struct ClearanceHole: Shape3D {
    let diameter: Double
    let depth: Double
    let edgeProfile: EdgeProfile?
    let boltHeadRecess: any Geometry3D

    /// Creates a clearance hole with a custom head recess geometry.
    ///
    /// - Parameters:
    ///   - diameter: The hole diameter (typically the bolt's major diameter).
    ///   - depth: The depth of the hole.
    ///   - boltHeadRecess: Custom geometry for the head recess.
    public init(diameter: Double, depth: Double, boltHeadRecess: any Geometry3D) {
        self.diameter = diameter
        self.depth = depth
        self.edgeProfile = nil
        self.boltHeadRecess = boltHeadRecess
    }

    /// Creates a clearance hole with an optional edge profile.
    ///
    /// - Parameters:
    ///   - diameter: The hole diameter (typically the bolt's major diameter).
    ///   - depth: The depth of the hole.
    ///   - edgeProfile: Optional edge profile at the hole opening.
    public init(diameter: Double, depth: Double, edgeProfile: EdgeProfile? = nil) {
        self.diameter = diameter
        self.depth = depth
        self.edgeProfile = edgeProfile
        self.boltHeadRecess = Empty()
    }

    /// Creates a clearance hole with a countersink for flat head fasteners.
    ///
    /// - Parameters:
    ///   - diameter: The hole diameter (typically the bolt's major diameter).
    ///   - depth: The depth of the hole.
    ///   - countersinkAngle: The cone angle of the countersink. Defaults to 90°.
    ///   - countersinkTopDiameter: The diameter at the top of the countersink.
    public init(diameter: Double, depth: Double, countersinkAngle: Angle = 90°, countersinkTopDiameter: Double) {
        self.diameter = diameter
        self.depth = depth
        self.edgeProfile = nil
        self.boltHeadRecess = Countersink.Shape(Countersink(
            angle: countersinkAngle, topDiameter: countersinkTopDiameter
        ))
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance
        let effectiveDiameter = diameter + tolerance

        Cylinder(diameter: effectiveDiameter, height: depth)
            .overhangSafe()
            .adding {
                boltHeadRecess.ifEmpty {
                    edgeProfile?.profile
                        .translated(x: effectiveDiameter / 2)
                        .revolved()
                }
                .within(z: ...depth)
            }
    }
}
