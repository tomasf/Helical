import Foundation
import SwiftSCAD

public protocol BoltHeadRecess: Shape3D {
}

public struct Countersink {
    let angle: Angle
    let topDiameter: Double
}

public struct Counterbore {
    let diameter: Double
    let depth: Double
}
