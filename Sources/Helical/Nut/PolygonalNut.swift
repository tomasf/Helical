import Foundation
import SwiftSCAD

public struct PolygonalNut: Nut {
    let thread: ScrewThread
    let sideCount: Int
    let thickness: Double
    let widthAcrossFlats: Double
    let topCorners: EdgeProfile
    let bottomCorners: EdgeProfile
    let innerChamferAngle: Angle

    public init(
        thread: ScrewThread,
        sideCount: Int,
        thickness: Double,
        widthAcrossFlats: Double,
        topCorners: EdgeProfile = .sharp,
        bottomCorners: EdgeProfile = .sharp,
        innerChamferAngle: Angle = .zero
    ) {
        self.thread = thread
        self.sideCount = sideCount
        self.thickness = thickness
        self.widthAcrossFlats = widthAcrossFlats
        self.topCorners = topCorners
        self.bottomCorners = bottomCorners
        self.innerChamferAngle = innerChamferAngle
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            let polygon = RegularPolygon(sideCount: sideCount, apothem: (widthAcrossFlats + environment.relativeTolerance) / 2)
            polygon
                .rotated(180° / Double(sideCount))
                .extruded(height: thickness)
                .intersection {
                    Circle(diameter: polygon.circumradius * 2)
                        .extruded(height: thickness, topEdge: topCorners, bottomEdge: bottomCorners, method: .convexHull)
                }
                .subtracting {
                    Screw(thread: thread, length: thickness + 0.002)
                        .translated(z: -0.001)

                    if innerChamferAngle.radians > .ulpOfOne {
                        Cylinder(
                            bottomDiameter: thread.majorDiameter + environment.tolerance,
                            topDiameter: thread.minorDiameter + environment.tolerance,
                            height: thread.depth * tan(90° - innerChamferAngle / 2)
                        )
                        .translated(z: -thickness / 2 - 0.01)
                        .symmetry(over: .z)
                        .translated(z: thickness / 2)
                    }
                }
        }
    }

    public func makeNutTrap(depthClearance: Double) -> any Geometry3D {
        EnvironmentReader { environment in
            RegularPolygon(sideCount: sideCount, apothem: (widthAcrossFlats + environment.tolerance) / 2)
                .rotated(180° / Double(sideCount))
                .extruded(height: thickness + depthClearance)
        }
    }
}
