import Foundation
import SwiftSCAD

public protocol BoltPoint: Shape3D {
    var boltLength: Double { get }
    var negativeBody: any Geometry3D { get }
}

public extension BoltPoint {
    var body: any Geometry3D { Box(.zero) }
    @UnionBuilder3D var negativeBody: any Geometry3D { Box(.zero) }
}
