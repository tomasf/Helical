import Foundation
import SwiftSCAD

protocol BoltHeadRecess: Shape3D {
}

struct Countersink {
    let angle: Angle
    let topDiameter: Double
}

struct Counterbore {
    let diameter: Double
    let depth: Double
}
