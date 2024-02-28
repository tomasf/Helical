import Foundation
import SwiftSCAD

protocol BoltPoint: Shape3D {
    var negativeBody: any Geometry3D { get }
}

extension BoltPoint {
    var body: any Geometry3D { Box(.zero) }
    @UnionBuilder3D var negativeBody: any Geometry3D { Box(.zero) }
}
